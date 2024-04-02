# README - Frontend

This README provides an overview of the frontend of the web application developed using Vue3. Here you will find information about the project structure and key features.

## Overview

The frontend of this web application is developed using Vue3 with Vite as the build tool, providing a modern and efficient development environment. The backend is powered by Java Spring Boot, offering robustness and scalability for handling business logic and data management. The application utilizes MySQL as the database management system to store and retrieve data efficiently.

Additionally, the application integrates a Telegram bot for sending both automatic and manual messages, enhancing communication and notification capabilities. To streamline deployment and ensure consistency across environments, the application is dockerized, facilitating easy setup and deployment to various platforms.

Furthermore, all data related to virtual machines is automated through a script that fetches data from InfluxDB and stores it in the MySQL database. This approach reduces the volume of data processed, improving efficiency. The application leverages Proxmox as the server hosting the virtual machines, ensuring reliable performance and management of virtualized environments.

## Key Features

- **Accounting Dashboard**: Allows users to visualize charts and tables displaying the company's accounting, including income, expenses, and balances.

- **Invoice Authorization**: Professors have the ability to authorize invoices, while students must accept corresponding payments.

- **Transaction Management**: Enables users to make new transactions within the application.

- **Fixed Expenses**: Automatically charged at the end of each sprint, with the option to adjust sprint start and end dates.

- **Project Management**: Allows the creation of new projects in each sprint, allocation of hours to projects, and real-time control of time spent on each project.

- **Virtual Machine Control**: Enables users to monitor and manage virtual machines assigned to each team.

- **Information Centralization**: Provides a space to record IP addresses and credentials of team devices, keeping all information centralized and accessible.

## Project Structure

The project structure follows Vue3's standard conventions:

- **/src**: Contains all the source code of the application.
  - **/assets**: Static resources such as images, fonts, etc.
  - **/components**: Reusable Vue components.
  - **/views**: Top-level views of the application.
  - **/router**: Routing configuration.
  - **/store**: Vuex configuration for managing the application state.
  - **/styles**: Global styles of the application.
  
## Getting Started

To start working with the project, follow these steps:

1. **Clone the repository from GitHub, Frontend and Backend**:
```
git clone https://github.com/Espuga/vue-accounting.git
```
```
git clone https://github.com/Espuga/api-accounting.git
```

### Configure Backend:
1. **Install dependencies**: 

```
cd api-accounting
mvn install
```

2. **Set Up Database**:
```
sudo mysql -u user -p
create database accounting;
sudo mysql -u user -p accounting < ./src/main/resources/sql/accounting.sql
```

3. **Configure the environment variable file**.
```
DB_SERVER=127.0.0.1
DB_PORT=3306
DB_SCHEMA=accounting
DB_USER=user
DB_PASSWD=user_passwd
DB_SCHEMA_PROXMOX=proxmox
TELEGRAM_BOT_TOKEN=xxxxxxxxxxxxxxxx
PORT=8080
```

4. **Start the Backend Server**:
```
mvn spring-boot:run
```

### Configure Frontend:
1. **Install dependencies**:
```
cd vue-accounting
npm install
```

2. **Configure the environment variable file**.
```
VITE_APP_BACKEND_IP=http://127.0.0.1:8080
```

3. **Start the development server**:
```
npm run dev
```



---

Marc Espuga