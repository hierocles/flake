#!/usr/bin/env python3
"""
Export all torrents from Transmission and add them to qBittorrent via magnet links.
"""

import argparse
import json
import sys

import requests


class TransmissionClient:
    def __init__(self, host: str, port: int, username: str = None, password: str = None):
        self.url = f"http://{host}:{port}/transmission/rpc"
        self.session_id = None
        self.auth = (username, password) if username and password else None

    def _request(self, method: str, arguments: dict = None) -> dict:
        headers = {}
        if self.session_id:
            headers["X-Transmission-Session-Id"] = self.session_id

        payload = {"method": method}
        if arguments:
            payload["arguments"] = arguments

        response = requests.post(
            self.url,
            json=payload,
            headers=headers,
            auth=self.auth,
        )

        # Handle CSRF token - Transmission returns 409 with session ID on first request
        if response.status_code == 409:
            self.session_id = response.headers.get("X-Transmission-Session-Id")
            return self._request(method, arguments)

        response.raise_for_status()
        return response.json()

    def get_torrents(self) -> list[dict]:
        """Get all torrents with their magnet links and labels."""
        result = self._request(
            "torrent-get",
            {"fields": ["id", "name", "hashString", "magnetLink", "labels"]},
        )
        return result.get("arguments", {}).get("torrents", [])


class QBittorrentClient:
    def __init__(self, host: str, port: int, username: str, password: str):
        self.base_url = f"http://{host}:{port}"
        self.session = requests.Session()
        self.session.headers["Referer"] = self.base_url
        self._login(username, password)

    def _login(self, username: str, password: str):
        response = self.session.post(
            f"{self.base_url}/api/v2/auth/login",
            data={"username": username, "password": password},
        )
        response.raise_for_status()
        if response.text != "Ok.":
            raise Exception(f"qBittorrent login failed: {response.text}")

    def get_categories(self) -> set[str]:
        """Get existing category names."""
        response = self.session.get(f"{self.base_url}/api/v2/torrents/categories")
        response.raise_for_status()
        return set(response.json().keys())

    def create_category(self, name: str, save_path: str = "") -> bool:
        """Create a category. Returns True on success."""
        response = self.session.post(
            f"{self.base_url}/api/v2/torrents/createCategory",
            data={"category": name, "savePath": save_path},
        )
        # 409 means category already exists, which is fine
        if response.status_code == 409:
            return True
        response.raise_for_status()
        return True

    def add_torrent(
        self, magnet_link: str, paused: bool = False, category: str = None
    ) -> bool:
        """Add a torrent via magnet link. Returns True on success."""
        data = {
            "urls": magnet_link,
            "paused": "true" if paused else "false",
        }
        if category:
            data["category"] = category

        response = self.session.post(
            f"{self.base_url}/api/v2/torrents/add",
            data=data,
        )
        response.raise_for_status()
        return response.text == "Ok."


def main():
    parser = argparse.ArgumentParser(
        description="Export torrents from Transmission and add to qBittorrent"
    )

    # Transmission arguments
    parser.add_argument("--transmission-host", default="localhost")
    parser.add_argument("--transmission-port", type=int, default=9091)
    parser.add_argument("--transmission-user", default=None)
    parser.add_argument("--transmission-pass", default=None)

    # qBittorrent arguments
    parser.add_argument("--qbittorrent-host", default="localhost")
    parser.add_argument("--qbittorrent-port", type=int, default=8080)
    parser.add_argument("--qbittorrent-user", default="admin")
    parser.add_argument("--qbittorrent-pass", default="adminadmin")

    # Options
    parser.add_argument(
        "--paused", action="store_true", help="Add torrents in paused state"
    )
    parser.add_argument(
        "--dry-run", action="store_true", help="Only list torrents, don't add to qBittorrent"
    )

    args = parser.parse_args()

    # Connect to Transmission
    print(f"Connecting to Transmission at {args.transmission_host}:{args.transmission_port}...")
    transmission = TransmissionClient(
        args.transmission_host,
        args.transmission_port,
        args.transmission_user,
        args.transmission_pass,
    )

    # Get all torrents
    torrents = transmission.get_torrents()
    print(f"Found {len(torrents)} torrents in Transmission")

    if not torrents:
        print("No torrents to migrate")
        return

    # Collect all unique labels to create as categories
    all_labels = set()
    for t in torrents:
        labels = t.get("labels", [])
        all_labels.update(labels)

    if args.dry_run:
        print("\nDry run - torrents that would be migrated:")
        for t in torrents:
            labels = t.get("labels", [])
            label_str = f" [{labels[0]}]" if labels else ""
            print(f"  - {t['name']}{label_str}")
        if all_labels:
            print(f"\nCategories that would be created: {', '.join(sorted(all_labels))}")
        return

    # Connect to qBittorrent
    print(f"\nConnecting to qBittorrent at {args.qbittorrent_host}:{args.qbittorrent_port}...")
    qbittorrent = QBittorrentClient(
        args.qbittorrent_host,
        args.qbittorrent_port,
        args.qbittorrent_user,
        args.qbittorrent_pass,
    )

    # Create categories for all labels
    if all_labels:
        existing_categories = qbittorrent.get_categories()
        new_categories = all_labels - existing_categories
        if new_categories:
            print(f"\nCreating {len(new_categories)} categories...")
            for label in sorted(new_categories):
                try:
                    qbittorrent.create_category(label)
                    print(f"  Created category: {label}")
                except Exception as e:
                    print(f"  Failed to create category {label}: {e}")

    # Add torrents to qBittorrent
    success_count = 0
    fail_count = 0

    print("\nAdding torrents...")
    for torrent in torrents:
        name = torrent.get("name", "Unknown")
        magnet = torrent.get("magnetLink")
        labels = torrent.get("labels", [])
        category = labels[0] if labels else None

        if not magnet:
            print(f"  SKIP: {name} (no magnet link available)")
            fail_count += 1
            continue

        try:
            if qbittorrent.add_torrent(magnet, paused=args.paused, category=category):
                cat_str = f" [{category}]" if category else ""
                print(f"  OK: {name}{cat_str}")
                success_count += 1
            else:
                print(f"  FAIL: {name}")
                fail_count += 1
        except Exception as e:
            print(f"  ERROR: {name} - {e}")
            fail_count += 1

    print(f"\nMigration complete: {success_count} succeeded, {fail_count} failed")


if __name__ == "__main__":
    main()
