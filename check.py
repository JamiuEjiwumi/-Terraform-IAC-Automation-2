import json

numberOfResourcesExpected = 42
minAcceptable = 20
validationResource = None


class Check:
    def __init__(self, tfstate="terraform.tfstate") -> None:
        try:
            with open(tfstate, 'r') as s:
                self.tfstate = json.loads(s.read())
                self.resources = self.tfstate["resources"]
                self.resources_names = [resource["name"] for resource in self.resources]
        except:
            self.tfstate = None
            

    def wasItSucessful(self):
        print("Doing Pre-Checks....")
        print("Expected Resource:", numberOfResourcesExpected)
        print("Created:", len(self.resources))
        if self.tfstate == None:
            return -1
    
        '''
        0: failed from the very beginging; destroy and restart
        1: partial sucess, consider as sucessful but should be refreshed (run apply again)
        2: everything deplpoyed successfully; good to go.
        '''
        

        if len(self.resources) < minAcceptable:
            return 0
        
        if validationResource in self.resources_names:
            try:
                r = self.resources[self.resources_names.index(validationResource)]
                id = r["instances"][0]["attributes"]["id"] #has an id if completely deployed
                if id is not None:
                    return 2
            except:
                return 1
        if len(self.resources) > minAcceptable and len(self.resources) < numberOfResourcesExpected:
            return 1
        
        return 0
            
            
        




        
            
        




        