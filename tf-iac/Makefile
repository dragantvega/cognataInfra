.PHONY: build run test

build: 
		npm install -g @angular/cli;\
		git config --global user.name "FIRST_NAME LAST_NAME";\
		git config --global user.email "MY_NAME@example.com";\
		ng new my-app --skip-git --defaults;\
		cd my-app;\
		ng build --configuration "production";\
		npm install;\