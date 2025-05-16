terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~>1"
    }
  }
}

resource "hcloud_network" "default" {
  name     = "default"
  ip_range = "10.1.0.0/16"
}

resource "hcloud_network_subnet" "default" {
  ip_range     = "10.1.0.0/24"
  network_id   = hcloud_network.default.id
  network_zone = "ap-southeast"
  type         = "server"
}

resource "hcloud_firewall" "default" {
  name = "default"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = 22
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_ssh_key" "default" {
  name = "default"
  public_key = file("~/.ssh/id_ed25519.pub")

  lifecycle {
    ignore_changes = [public_key]
  }
}

resource "hcloud_primary_ip" "srv-htz-01" {
  name          = "srv-htz-01"
  assignee_type = "server"
  auto_delete   = false
  type          = "ipv6"
  datacenter    = "sin-dc1"
}

resource "hcloud_server" "srv-htz-01" {
  name        = "srv-htz-01"
  image       = "debian-12"
  datacenter  = "sin-dc1"
  server_type = "ccx23"
  keep_disk   = true
  ssh_keys = [hcloud_ssh_key.default.id]

  public_net {
    ipv4_enabled = false
    ipv6         = hcloud_primary_ip.srv-htz-01.id
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.default.id
    alias_ips = []
  }

  firewall_ids = [hcloud_firewall.default.id]

  lifecycle {
    ignore_changes = [ssh_keys]
  }
}
