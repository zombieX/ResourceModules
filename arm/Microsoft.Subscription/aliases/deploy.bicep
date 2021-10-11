targetScope = 'tenant' // required by subscription resource type

@description('Required. Unique alias name. Unique and linking ID')
param subscriptionAliasName string

@description('Required. Subscription display name.')
param displayName string

@description('Optional. Target management group where the subscription will be created.')
param targetManagementGroupId string = ''

@description('Required. The account to be invoiced for the subscription. e.g. "/providers/Microsoft.Billing/billingAccounts/12345678/enrollmentAccounts/123456"')
param billingScope string

@description('Required.')
param resellerId string

@description('Optional. Subscription workload.')
@allowed([
  'Production'
  'DevTest'
])
param workload string = 'Production'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Resource tags.')
param tags object = {}

var builtInRoleNames = {}

resource subscription 'Microsoft.Subscription/aliases@2020-09-01' = {
  name: subscriptionAliasName
  properties: {
    workload: workload
    displayName: displayName
    billingScope: billingScope
    resellerId: resellerId
    // subscriptionId: tenantResourceId('Microsoft.Management/managementGroups/', targetManagementGroupId)
    // managementGroupId: tenantResourceId('Microsoft.Management/managementGroups/', targetManagementGroupId)

  }
}

module tagDeployment './.bicep/nested_tenant_tags.bicep' = if (!empty(tags)) {
  name: 'nested-tags'
  params: {
    subscriptionId: subscription.id
    tags: tags
  }
}

module RBACDeployment './.bicep/nested_tenant_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name)}-Subscription-Rbac-${index}'
  params: {
      roleAssignmentObj: roleAssignment
      builtInRoleNames: builtInRoleNames
      subscriptionId: subscription.id
    }
}]

output subscriptionId string = subscription.id
// ???????
output tags object = tags
output roleAssignments array = roleAssignments
