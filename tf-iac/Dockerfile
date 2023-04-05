FROM node:14

WORKDIR /build
RUN npm install -g @angular/cli
RUN git config --global user.name "FIRST_NAME LAST_NAME" && git config --global user.email "MY_NAME@example.com"
RUN ng new my-app --skip-git --defaults && cd my-app && ng build --configuration "production" && npm install
EXPOSE 4200
EXPOSE 80
WORKDIR /build/my-app
#CMD [ "npm", "start", "--prefix /build/my-app" ]
CMD [ "ng", "serve", "--host=0.0.0.0" ]