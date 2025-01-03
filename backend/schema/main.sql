CREATE TABLE BUSINESS (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    phone_number VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    city VARCHAR(255),
    country VARCHAR(255) NOT NULL,
    street VARCHAR(255),
    website_url VARCHAR(255),
    industry VARCHAR(255) NOT NULL,
    managerid_card_url VARCHAR(255) NOT NULL,
    manager_personal_photo_url VARCHAR(255) NOT NULL,
    business_logo_url VARCHAR(255) NOT NULL
);

CREATE TABLE EMPLOYEE (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    role INT NOT NULL,
    account_creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    hashed_password VARCHAR(255) NOT NULL,
    verified INT NOT NULL DEFAULT 1,
    business_id INT NOT NULL,
    FOREIGN KEY (business_id) REFERENCES BUSINESS(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CUSTOMER (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    phone_number VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address TEXT,
    type INT NOT NULL,
    lead_source VARCHAR(255) NOT NULL,
    preferred_contact_method BOOLEAN NOT NULL,
    business_id INT NOT NULL,
    FOREIGN KEY (business_id) REFERENCES BUSINESS(id) ON DELETE CASCADE ON UPDATE CASCADE,
    added_by INT NOT NULL,
    FOREIGN KEY (added_by) REFERENCES EMPLOYEE(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE DEAL (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    status INT NOT NULL,
    description TEXT NOT NULL,
    date_opened TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_closed TIMESTAMP,
    due_date TIMESTAMP NOT NULL,
    expenses DECIMAL NOT NULL,
    customer_budget DECIMAL NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(id) ON DELETE CASCADE ON UPDATE CASCADE,
    deal_opener INT NOT NULL,
    FOREIGN KEY (deal_opener) REFERENCES EMPLOYEE(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    deal_executor INT,
    date_claimed TIMESTAMP,
    FOREIGN KEY (deal_executor) REFERENCES EMPLOYEE(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE FINANCIAL_RECORD (
    id SERIAL PRIMARY KEY,
    amount DECIMAL NOT NULL,
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    type INT NOT NULL,
    description TEXT NOT NULL,
    payment_method INT NOT NULL,
    business_id INT NOT NULL,
    FOREIGN KEY (business_id) REFERENCES BUSINESS(id) ON DELETE CASCADE ON UPDATE CASCADE,
    deal_id INT NOT NULL,
    FOREIGN KEY (deal_id) REFERENCES DEAL(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE BADGE (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    type INT NOT NULL,
    required_points INT NOT NULL
);

CREATE TABLE EMPLOYEE_BADGE (
    date_awarded TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    employee_id INT NOT NULL,
    badge_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES BADGE(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (employee_id, badge_id)
);

CREATE TABLE NOTIFICATION (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    priority INT NOT NULL,
    type INT NOT NULL,
    seen BOOLEAN NOT NULL DEFAULT FALSE,
    recipient INT NOT NULL,
    FOREIGN KEY (recipient) REFERENCES EMPLOYEE(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TARGET (
    id SERIAL PRIMARY KEY,
    type INT NOT NULL,
    goal INT NOT NULL,
    deadline TIMESTAMP NOT NULL,
    description TEXT NOT NULL,
    start_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE EMPLOYEE_TARGET (
    employee_id INT NOT NULL,
    target_id INT NOT NULL,
    progress INT NOT NULL DEFAULT 0,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (target_id) REFERENCES TARGET(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (employee_id, target_id)
);

CREATE TABLE EMPLOYEE_PROFILE (
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date TIMESTAMP NOT NULL,
    phone_number VARCHAR(255) NOT NULL,
    profile_picture_url VARCHAR(255),
    address TEXT,
    hire_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ACTIVITY_LOG (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    content TEXT NOT NULL,
    type INT NOT NULL,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id) ON DELETE SET NULL ON UPDATE CASCADE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(id) ON DELETE SET NULL ON UPDATE CASCADE,
    deal_id INT,
    FOREIGN KEY (deal_id) REFERENCES DEAL(id) ON DELETE SET NULL ON UPDATE CASCADE,
    target_id INT,
    FOREIGN KEY (target_id) REFERENCES TARGET(id) ON DELETE SET NULL ON UPDATE CASCADE,
    business_id INT NOT NULL,
    FOREIGN KEY (business_id) REFERENCES BUSINESS(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ADMIN (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    hashed_password VARCHAR(255) NOT NULL,
    privilege INT NOT NULL DEFAULT 0
);

CREATE TABLE FORGOT_PASSWORD (
    employee_id INT PRIMARY KEY,
    code VARCHAR(255) NOT NULL,
    expiry TIMESTAMP NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(id) ON DELETE CASCADE ON UPDATE CASCADE
);
