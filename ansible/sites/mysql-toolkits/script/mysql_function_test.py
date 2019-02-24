import pymysql.cursors
import time
import sys


def get_connection():
    return pymysql.connect(host='192.168.1.210',
                           user='admin',
                           password='aaaaaa',
                           db='db_dba',
                           charset='utf8mb4',
                           cursorclass=pymysql.cursors.DictCursor)


def query(connection, sql, times):
    with connection.cursor() as cursor:
        for _ in range(times):
            cursor.execute(sql)


def run(times):
    sql_join = """
select 
  a.order_id,       
  b.address_name  as address_name_shipper,
  c.address_name  as address_name_receiver,
  d.address_name  as address_name_notify
from t_order a
   left join t_address b on a.address_id_shipper=b.address_id
   left join t_address c on a.address_id_receiver=c.address_id
   left join t_address d on a.address_id_notify=d.address_id
where order_id = 1
    """

    sql_function = """
select 
  order_id,
  f_get_address_name(address_id_shipper) as address_name_shipper,
  f_get_address_name(address_id_receiver) as address_name_receiver,
  f_get_address_name(address_id_notify) as address_name_notify
from t_order 
where order_id = 1;
    """

    start_time1 = time.time()
    query(get_connection(), sql_join, times)
    end_time1 = time.time()
    total1 = end_time1 - start_time1

    start_time2 = time.time()
    query(get_connection(), sql_function, times)
    end_time2 = time.time()
    total2 = end_time2 - start_time2

    output = '{:15s} {:>10.2f}'
    print(output.format("run_times", times))
    print(output.format("sql_join", total1))
    print(output.format("sql_function", total2))
    print(output.format("diff", total2 - total1))


if __name__ == "__main__":
    times = len(sys.argv) > 1 and int(sys.argv[1]) or 1000
    run(times)
