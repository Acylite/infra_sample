resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.subnet_cidr
}



resource "google_compute_firewall" "firewall_rules" {
  network = google_compute_network.vpc_network.name
  name                    = "allow-dataproc-ingress"
  description             = "allow dataproc connection"
  direction               = "INGRESS"
  priority                = 50
  source_ranges           = ["0.0.0.0/0", "10.128.0.0/9"]
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
      protocol = "udp"
      ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}


resource "google_compute_firewall" "firewall_rules_egress" {
  network = google_compute_network.vpc_network.name
  name                    = "allow-public-egress"
  description             = "allow outgoing traffic"
  direction               = "EGRESS"
  priority                = 100
  destination_ranges      = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
      protocol = "udp"
      ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

output "vpc_self_link" {
  value = google_compute_network.vpc_network.self_link
}

output "subnet_self_link" {
  value = google_compute_subnetwork.vpc_subnet.self_link
}