targetScope = 'subscription'

param roleAssignmentObj object
param builtInRoleNames object
param subscriptionId string

resource roleAssigment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for principalId in roleAssignmentObj.principalIds: {
  name: '${guid(subscriptionId, principalId, roleAssignmentObj.roleDefinitionIdOrName)}'
  properties: {
    roleDefinitionId: (contains(builtInRoleNames, roleAssignmentObj.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignmentObj.roleDefinitionIdOrName] : roleAssignmentObj.roleDefinitionIdOrName)
    principalId: principalId
  }
}]
