# שלב 1: Build של אפליקציית Angular
FROM node:18-alpine AS build

# תיקיית עבודה בתוך הקונטיינר
WORKDIR /app

# העתקת קבצי הגדרות npm
COPY package*.json ./

# התקנת תלויות + Angular CLI
RUN npm install -g @angular/cli@17 \
    && npm install

# העתקת שאר קבצי הפרויקט
COPY . .

# ביצוע build בקונפיגורציית production
RUN ng build --configuration production

# שלב 2: שרת Nginx שיגיש את ה-build
FROM nginx:alpine

# מחיקת קובץ ההגדרות הדיפולטי של Nginx (לא חובה אבל יפה)
RUN rm -rf /usr/share/nginx/html/*

# העתקת קבצי ה-build מהשלב הראשון לתיקייה ש-Nginx מגיש ממנה
# שים לב: את "my-angular-app" צריך להחליף לשם האפליקציה שלך מתוך angular.json
COPY --from=build /app/dist/my-angular-app/ /usr/share/nginx/html/

# חשיפת פורט 80
EXPOSE 80

# פקודת הרצה של Nginx
CMD ["nginx", "-g", "daemon off;"]
