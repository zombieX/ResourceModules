targetScope = 'tenant'
param subscriptionId string
param roleAssignmentObj object
param builtInRoleNames object

module tagDeploymentName './nested_subscription_rbac.bicep' = {
  name: 'nestedrBACDeploy-${uniqueString(subscriptionId)}'
  scope: subscription(subscriptionId)
  params: {
    roleAssignmentObj: roleAssignmentObj
    builtInRoleNames: builtInRoleNames
    subscriptionId: subscriptionId
  }
}
