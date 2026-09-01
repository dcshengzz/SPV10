=======================================================================
 #####                                   ###                            
#     # ###### ##### #    # #####         #  #    # ##### #####   ####  
#       #        #   #    # #    #        #  ##   #   #   #    # #    # 
 #####  #####    #   #    # #    #        #  # #  #   #   #    # #    # 
      # #        #   #    # #####         #  #  # #   #   #####  #    # 
#     # #        #   #    # #             #  #   ##   #   #   #  #    # 
 #####  ######   #    ####  #            ### #    #   #   #    #  ####  
=======================================================================
The React part you saw inside StarterApplication in actually build from the other project which is where we maintain the React code.

Basically there are two steps to setup:
1. React Project Setup
2. API Connection Setup



==================================================================================================================================
######                                   ######                                                  #####                             
#     # ######   ##    ####  #####       #     # #####   ####       # ######  ####  #####       #     # ###### ##### #    # #####  
#     # #       #  #  #    #   #         #     # #    # #    #      # #      #    #   #         #       #        #   #    # #    # 
######  #####  #    # #        #         ######  #    # #    #      # #####  #        #          #####  #####    #   #    # #    # 
#   #   #      ###### #        #         #       #####  #    #      # #      #        #               # #        #   #    # #####  
#    #  #      #    # #    #   #         #       #   #  #    # #    # #      #    #   #         #     # #        #   #    # #      
#     # ###### #    #  ####    #         #       #    #  ####   ####  ######  ####    #          #####  ######   #    ####  #      
==================================================================================================================================
The project you checkout initially will not have the node_module folder.

Which means you have to run install the npm on your target React Project.

And these command you will have to run too:
npm install
npm install -g webpack@3.12.0
npm install -g webpack-dev-server@2.11.5 / npm install -g webpack-dev-server@3.11.2

* Note that to it will have connection with swz-builder/swz-survey-builder.
* So you have to run the (ONLY) command npm install for swz-builder/swz-survey-builder, in order to proceed npm start on your React Project.

After the installation of the above command, and now you can run "npm start" for your target React Project.

If you got any error, restart the process by delete node_module folder and package-lock.json.




===================================================================================================================================
   #    ######  ###        #####                                                                  #####                             
  # #   #     #  #        #     #  ####  #    # #    # ######  ####  ##### #  ####  #    #       #     # ###### ##### #    # #####  
 #   #  #     #  #        #       #    # ##   # ##   # #      #    #   #   # #    # ##   #       #       #        #   #    # #    # 
#     # ######   #        #       #    # # #  # # #  # #####  #        #   # #    # # #  #        #####  #####    #   #    # #    # 
####### #        #        #       #    # #  # # #  # # #      #        #   # #    # #  # #             # #        #   #    # #####  
#     # #        #        #     # #    # #   ## #   ## #      #    #   #   # #    # #   ##       #     # #        #   #    # #      
#     # #       ###        #####   ####  #    # #    # ######  ####    #   #  ####  #    #        #####  ######   #    ####  #      
===================================================================================================================================
Note that you will have to run the StarterApplication on http://localhost:48800/ so the React project can get data from the API.

And you might notice both project having different URL (http://localhost:48800/ and http://localhost:8092/), so you could probably encountered CORS issue.

To solve the CORS issue, you will have to modify the section system.webServer > httpProtocol > customHeaders in file .vs\config\applicationhost.config

By adding these line:
<add name="Access-Control-Allow-Origin" value="*" />
<add name="Access-Control-Allow-Headers" value="Content-Type" />

After modified this is what you should got:

        <httpProtocol>
            <customHeaders>
                <clear />
                <add name="X-Powered-By" value="ASP.NET" />
		<add name="Access-Control-Allow-Origin" value="*" />
		<add name="Access-Control-Allow-Headers" value="Content-Type" />
            </customHeaders>
            <redirectHeaders>
                <clear />
            </redirectHeaders>
        </httpProtocol>
		
Make sure you restart the StarterApplication (http://localhost:48800/) to have IIS gets the update of this config.

Now you should have both application connected.





=====================================================================================
######                                                 ###                            
#     # #####   ####       # ######  ####  #####        #  #    # ##### #####   ####  
#     # #    # #    #      # #      #    #   #          #  ##   #   #   #    # #    # 
######  #    # #    #      # #####  #        #          #  # #  #   #   #    # #    # 
#       #####  #    #      # #      #        #          #  #  # #   #   #####  #    # 
#       #   #  #    # #    # #      #    #   #          #  #   ##   #   #   #  #    # 
#       #    #  ####   ####  ######  ####    #         ### #    #   #   #    #  ####  
=====================================================================================
Here is a little intro for the React project:

swz-admin is used in /admin for administrative jobs
swz-admin is for super admin which is not supposed to be used by application users
swz-app is used in other pages other then /admin for form rendering
swz-builder is for system form design

swz-survey-admin and swz-useradmin are derived from it and is used for application users
swz-survey-builder is for survey form design (not system form)





Note: swz-app is now maintained on the intranet side and the compiled js copied to the internet side. Commit be296ef of 2021-08-20 has removed the unmaintained copies of folders for swz-app and swz-builder jsx sources from the internet branch.
