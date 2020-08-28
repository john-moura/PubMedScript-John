# PubMedScript README
Step-by-step instructions on how to use the PubMedScript and also how to import the results into your MySQL local database.

## Preparing your environment
1. Install gem HTTParty (responsible for the http requests)
    ```
    $ sudo gem install httparty
    ```
2. Install gem pry, used for debug
    ```
    $ sudo gem install pry
    ```

## Using the PubMedScript
1. Open your Terminal
2. Navegate to the folder where you want to clone this repo
3. Clone the git repo:
    ```unix
    $ git clone https://github.com/nhaiara/PubMedScript-John
    ```
4. Navigate into the newly create folder
5. Run the script using the following command
    ```unix
    $ ruby PubMedScript.rb
    ```
6. Answer the number of the initial and final page to extract data
7. Wait the script to finish the execution, and once done, the CSV files will be inside the folder _results_.

Note: The script is configured to use 100 results per page in the PubMed website, which is the max value, if you want to reduce it, I have to change the value of the variable `size` inside the script.

__________________________________________________________________________________________
## Importing the CSV file into the database
Downlod the tools in the [following link](https://drive.google.com/drive/folders/1RddOWMtU1v1nAaBxKk1iuPAbcr8mXjef?usp=sharing).

### Step 1: Install and set the MySQL Server
1. Download **MySQL Server**
2. Run the .dmg that you download, it will not open due to security reasons
3. Go to System Preferences > Privacy and authorise the file to Run
4. The wizard window will be, follow the steps
5. Create a password for your root user (recommended "password") and finish the installation
6. Go to your Terminal and add this environment variable:
    ```unix
    $ export PATH=${PATH}:/usr/local/mysql/bin
    ```

### Step 2: Install MySQLWorkbench and connect to the MySQL Server
1. Download and install **MySQL Workbench**
2. Move the app downloaded to you applications folder
3. Open the MySQL Workbench
4. Click on + for a new connection:
    - Use "localhost" in the connection name field
    - Confirm if the IP is 127.0.0.1 and the port is 3306 and click in "OK"
            - If any error shows up, start the Workbench as a administrator (Terminal > sudo open MySQLWorkbench.app)
    - It will require you the password, fill it with the created password, and it will connect.

### Step 3: Create DATABASE and TABLE:
1. In the MySQLWorkbench type the following script to create the database:
  ```CREATE DATABASE pubmed_results;```
2. Check that your database was created successfully:
  ```SHOW DATABASE;```
3. Define the recently created that base to be used for the next commands:
  ```USE pubmed_results;```
4. Create the table where the CSV are going to be imported and commit:
    ```sql
    CREATE TABLE IF NOT EXISTS PubMedList (
        list_id INT AUTO_INCREMENT,
        title VARCHAR(5000) NOT NULL,
        author VARCHAR(5000) NOT NULL,
        Affiliation VARCHAR(5000) NOT NULL,
        EMAIL VARCHAR(1000) NULL,
        PRIMARY KEY (list_id)
    );
    commit;
    ```
5. Check if the table was correctly created:
  ```SELECT * FROM PubMedList;```

### Step 4: Import CSV datafile
1. In the results area of MySQLWorkbench, click on the icon "data import" and follow the wizard steps:
    - Choose the CSV file
    - Set the created table as the destiny of the import
    - Set the relationship between the CSV headers and the table columns
    - Follow the process and validate the sum of rows imported.
2. And **_Voalá!_** Enjoy your affiliation results!
