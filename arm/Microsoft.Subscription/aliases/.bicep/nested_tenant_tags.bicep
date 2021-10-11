targetScope = 'tenant'
param subscriptionId string
param tags object

module tagDeploymentName './nested_subscription_tags.bicep' = {
  name: 'nestedTagDeploy-${uniqueString(subscriptionId)}'
  scope: subscription(subscriptionId)
  params: {
    tags: tags
  }
}
