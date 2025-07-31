
# https://opensheet.elk.sh/1AxnotD9U9kKOluFNRFPQoddXRg4ffVHaamdDIj31UhM/networks

data "http" "feeds" {
  url = "https://opensheet.elk.sh/1_AGRolYPId7YPwg07v-Fq6GXTF7Hx1MP1-AeGoScakA/feeds"
}
locals {
  feeds = jsondecode(data.http.feeds.response_body)
}

resource "checkpoint_management_network_feed" "feeds" {
  for_each = { for feed in local.feeds: feed.name => feed }
  name     = each.key
  feed_url = each.value.url
  #   username = "feed_username"
  #   password = "feed_password"
  feed_format     = "JSON"
  feed_type       = "IP Address"
  update_interval = 60
  json_query      = each.value.jq
}