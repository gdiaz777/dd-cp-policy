
# https://opensheet.elk.sh/1AxnotD9U9kKOluFNRFPQoddXRg4ffVHaamdDIj31UhM/networks
# https://docs.google.com/spreadsheets/d/1_AGRolYPId7YPwg07v-Fq6GXTF7Hx1MP1-AeGoScakA

data "http" "networks" {
  url = "https://opensheet.elk.sh/1_AGRolYPId7YPwg07v-Fq6GXTF7Hx1MP1-AeGoScakA/networks"
}
locals {
  networks = jsondecode(data.http.networks.response_body)
}

resource "checkpoint_management_network" "networks" {

  # ignore_warnings = true

  for_each = { for network in local.networks : network.name => network }

  name         = each.value.name
  subnet4 = each.value.ip
  mask_length4  = each.value.mask

  color = each.value.color
  
  tags  =  ["terraform"]

  comments = lookup(each.value, "comment", null)
}