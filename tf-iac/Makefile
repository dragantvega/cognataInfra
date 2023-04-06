.PHONY: build run test

build: 
		npm install -g @angular/cli;\
		git config --global user.name "FIRST_NAME LAST_NAME";\
		git config --global user.email "MY_NAME@example.com";\
		ng new cognataTestApp --skip-git --defaults;\
		cd cognataTestApp;\
		ng build --configuration "production";\
		npm install;\
		
test:
		echo "Running test!!!";\
		sleep 5;\