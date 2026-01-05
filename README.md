# Responder DNS Stub

A simple script to toggle systemd-resolved's DNS Stub Listener on/off, freeing port 53 for penetration testing tools like Responder.

## Why?

By default, systemd-resolved listens on port 53, which conflicts with tools like Responder, Metasploit, or custom DNS servers. This script makes it easy to toggle between normal DNS operation and pentest mode.

## Installation
```bash
sudo cp responder-dns-stub /usr/local/bin/
sudo chmod +x /usr/local/bin/responder-dns-stub
```

## Usage

Simply run the command to toggle between states:
```bash
sudo responder-dns-stub
```

The script automatically detects the current state and switches to the opposite.

## Typical Workflow
```bash
# Before pentest
sudo responder-dns-stub                    # Disable DNS Stub (frees port 53)
sudo python3 Responder.py -I tun0       # Run your tool

# After pentest
sudo responder-dns-stub                    # Re-enable DNS Stub (normal mode)
```

## Verification

Check if port 53 is free:
```bash
sudo ss -tulpn | grep :53
```

## Compatibility

- Fedora, Ubuntu, Debian, and other systemd-based distributions
- Requires systemd-resolved

## License

Use responsibly for authorized security testing only.
