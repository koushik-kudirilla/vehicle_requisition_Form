# Vehicle-Requisition-System

A web-based vehicle requisition application developed as part of an academic project. Built using Java EE technologies, this application automates vehicle request submission, approval workflows, and status tracking.

---

## 🛠️ Technologies Used

- **Java (JSP / Servlets)**
- **JDBC (MySQL)**
- **HTML5 / CSS3**
- **NetBeans IDE**
- **Tomcat Server (Localhost)**
- **MySQL Database**

---

## 📁 Project Structure

```
Vehicle-Requisition-System/
├── build/                           # Compiled files (ignored by Git)
│   ├── empty/
│   ├── generated-sources/
│   └── web/
│       ├── META-INF/
│       │   └── context.xml          # Deployment context file (ignored)
│       ├── images/                  # Image assets (ignored)
│       └── WEB-INF/
│           └── lib/                 # Runtime libraries (ignored)
├── nbproject/                       # NetBeans project configuration (ignored)
├── src/                             # Java source files
│   ├── controller/                  # Servlet controllers
│   ├── dao/                         # Data Access Objects
│   └── model/                       # JavaBeans or business logic classes
├── web/                             # Web application resources
│   ├── META-INF/
│   │   └── context.xml              # Deployment context file
│   ├── WEB-INF/
│   │   └── lib/                     # Runtime libraries (JAR files)
│   ├── images/                      # Logos and user icons
│   ├── css/                         # Stylesheets (styles.css)
│   └── jsp                          # JSP pages for user interfaces
├── database/                        # Database schema
│   └── vehicle_requisition.sql      # SQL schema and seed data
├── output/                          # Screenshots or demo outputs
├── .gitignore                       # Git ignore rules
└── README.md                        # Project documentation
```

---

## ✅ Features

- Admin login & user management  
- Employee vehicle request submission  
- Role-based dashboards (Employee, Admin, Senior Admin)  
- Approval workflow system (multi-level: Admin → Senior Admin)  
- Vehicle request status tracking  
- Log sheet generation and viewing for all roles  
- Secure database interactions  

---

## 🔒 Security Practices

This project incorporates several security techniques:

- **Authentication & Session Management**
- **Authorization Checks (Role-based)**
- **SQL Injection Prevention (via PreparedStatements)**
- **Secure Database Configuration**

---

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/koushik-kudirilla/vehicle_requisition_Form.git
cd vehicle_requisition_Form
```

### 2. Open in NetBeans

- Go to `NetBeans` > `File` > `Open Project`
- Select the `vehicle_requisition_Form` directory

### 3. Configure the Database

- Create a MySQL database named `vehicle_requisition_db`
- Import the SQL file located in `database/vehicle_requisition.sql`

### 4. Edit DB Credentials

Update the following in `web/META-INF/context.xml`:

```xml
<Resource name="jdbc/vehicle_requisition" auth="Container"
          type="javax.sql.DataSource"
          maxTotal="100" maxIdle="30" maxWaitMillis="10000"
          username="root" password="your_password"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://localhost:3306/vehicle_requisition_db"/>
```

### 5. Run the App

- Right-click the project in NetBeans > `Run`
- App will be deployed to:  
  **http://localhost:8080/vehicle_requisition_Form**

---

## 📌 Notes

- All build, temp, and IDE-specific files are excluded from version control using `.gitignore`
- Sensitive config files (e.g., context.xml with passwords) are included but require manual credential updates
- Adjust paths and configurations for deployment in a production environment
- Screenshots and demo outputs are available in the `output/` folder

---

## 👨‍💻 Authors

- **Koushik** – Developer, UI Designer, Integrator

---

## 📄 License

This project is for **academic/demo purposes only**. For real-world deployment or reuse, **proper security audits and enhancements are highly recommended**.
