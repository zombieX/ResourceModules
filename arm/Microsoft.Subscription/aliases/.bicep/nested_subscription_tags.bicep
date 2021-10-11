targetScope = 'subscription'

param tags object

resource tags_res 'Microsoft.Resources/tags@2020-10-01' ={
  name: 'default'
  properties: {
    tags: tags
  }
}
