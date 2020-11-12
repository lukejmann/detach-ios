App to temporarily block distracting iOS apps by creating a local proxy to filter network connections.

Putting on hold for now due to breaking changes in iOS 14's NetworkExtension. 

To run on iOS 14 without functioning proxy:  
- install Cocoapods: `sudo gem install cocoapods`   
- install Carthage: `brew install carthage`  
- update dependencies:    
    - `carthage update --platform iOS --no-use-binaries`  
    - `pod install`   
- change signing if necessary  
- change baseURL in DetachAPI to backend Docker    

[Backend Repo](http://github.com/lukejmann/detach2-backend)

To run backend servers with Docker 
- install Docker  
- `docker-compose build` 
 - `docker-compose up`

