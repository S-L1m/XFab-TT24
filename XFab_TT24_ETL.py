"""
Upgrade ideas
include LOGGING
include configparser

"""

import pandas as pd
import sqlalchemy
import pyodbc
import datetime as dt
from sqlalchemy import create_engine
from dateutil.relativedelta import relativedelta

def db_connection(server, database, username, password):
    # Connect to db
    SERVER = server #"LEMON\TT24"
    DATABASE = database #"XFab_TT24"
    USERNAME = username #""
    PASSWORD = password #""
    ConnectionString = f"DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}"
    conn = pyodbc.connect(ConnectionString)
    cursor = conn.cursor()

    test_query(cursor, conn)

    return cursor, conn

def init_today():
    current_date = dt.datetime.now()
    return current_date

def test_query(cursor, conn):
    test_query = "SELECT * FROM dim_company"

    # test query
    cursor.execute(test_query)
    test_df = pd.DataFrame(cursor.fetchall())
    #conn.close()
    print(test_df)

def staging_table_prep(cursor, current_date):

    # Extract data from Staging table
    staging_query = """SELECT * FROM Stage_Trade_Agreement"""
    cursor.execute(staging_query)
    df = pd.DataFrame.from_records(cursor.fetchall(), columns=[col[0] for col in cursor.description])
    df["ITEMID"] = df["ITEMID"].str.lstrip("*")
    df["RECID"] = df["RECID"].astype(str).str.rstrip(".")

    # new df to store each row in the df
    new_list = []

    # Iterate over each row in the df
    for index, row in df.iterrows():
        from_date = pd.to_datetime(row["FROM_DATE"])
        to_date = pd.to_datetime(row["TO_DATE"])

        # Create one row for every month that falls between the from/to date
        while from_date <= to_date:
            new_row = row.copy()
            new_row["FK_DATEID"] = from_date.strftime("%Y%m%d")
            new_list.append(new_row)

            # Increment from_date by 1 month
            from_date += relativedelta(months=1)

    transformed_df = pd.DataFrame(new_list)
    transformed_df["RECIDKEY"] = transformed_df["RECID"].astype(str) + transformed_df["FK_DATEID"].astype(str)
    transformed_df["RECIDKEY"] = transformed_df["RECIDKEY"].str.replace(".", "")
    #transformed_df["MODIFIED_DATE_TIME"] = current_date

    return transformed_df

def load_fact(cursor, conn, df):
    # Load new data into Trade_Agreement table

    for index,row in df.iterrows():
        conn.execute("""
            INSERT INTO Trade_Agreement(
            FK_DATEID, RECIDKEY, FK_CUSTOMERID, FK_CURRENCYID, FK_COMPANYID,
		    ITEMID, QUANTITY, PRICE, CONTRACTUAL_PRICE, VOLUME_QUANTITY,
    	    VOLUME_PRICE, NOT_VOLUME_RELATED, QUOTATIONID, INACTIVE_FLAG,
	        EXCHANGE_RATE, FROM_DATE, TO_DATE, RECID, MODIFIED_DATE_TIME) 
            values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
            """, row.FK_DATEID, row.RECIDKEY, row.FK_CUSTOMERID, row.FK_CURRENCYID,
            row.FK_COMPANYID, row.ITEMID, row.QUANTITY, row.PRICE, row.CONTRACTUAL_PRICE,
            row.VOLUME_QUANTITY, row.VOLUME_PRICE, row.NOT_VOLUME_RELATED, row.QUOTATIONID,
            row.INACTIVE_FLAG, row.EXCHANGE_RATE, row.FROM_DATE, row.TO_DATE, row.RECID, 
            row.MODIFIED_DATE_TIME
            )
    conn.commit()
    cursor.close()        
    conn.close()

def main():
    cursor, conn = db_connection(server = "LEMON\TT24", database = "XFab_TT24", username="",password="")    
    df = staging_table_prep(cursor)
    load_fact(cursor, conn, df)

main()

