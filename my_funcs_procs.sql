FONCTIONS DEMANDEES
CREATE OR REPLACE FUNCTION GET_NB_WORKERS(FACTORY_ID NUMBER) RETURN NUMBER AS
    nb_workers NUMBER;
BEGIN
    SELECT COUNT(*) INTO nb_workers
    FROM (
        SELECT *
        FROM workers_factory_1
        WHERE factory_id = GET_NB_WORKERS.factory_id
        UNION ALL
        SELECT *
        FROM workers_factory_2
        WHERE factory_id = GET_NB_WORKERS.factory_id
    );
    RETURN nb_workers;
END;

CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER AS
    nb_big_robots NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO nb_big_robots
    FROM robots
    WHERE parts_count > 3;
    RETURN nb_big_robots;
END;

CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2(100) AS
    best_supplier_name VARCHAR2(100);
BEGIN
    SELECT supplier_name INTO best_supplier_name
    FROM best_suppliers
    WHERE ROWNUM = 1;
    RETURN best_supplier_name;
END;

CREATE OR REPLACE FUNCTION GET_OLDEST_WORKER RETURN NUMBER AS
    oldest_worker_id NUMBER;
BEGIN
    SELECT worker_id INTO oldest_worker_id
    FROM (
        SELECT worker_id, start_date
        FROM workers_factory_1
        UNION ALL
        SELECT worker_id, start_date
        FROM workers_factory_2
    )
    ORDER BY start_date ASC
    FETCH FIRST ROW ONLY;
    RETURN oldest_worker_id;
END;

PROCEDURES DEMANDEES
CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) AS
BEGIN
    FOR i IN 1..NB_WORKERS LOOP
        INSERT INTO workers_factory_1 (first_name, last_name, start_date)
        VALUES ('worker_f_' || i, 'worker_l_' || i, TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J'));
    END LOOP;
END;

CREATE OR REPLACE PROCEDURE ADD_NEW_ROBOT(MODEL_NAME VARCHAR2(50)) AS
BEGIN
    INSERT INTO robots (model, main_location)
    SELECT MODEL_NAME, main_location
    FROM ROBOTS_FACTORIES
    WHERE model = MODEL_NAME
    FETCH FIRST ROW ONLY;
END;

CREATE OR REPLACE PROCEDURE SEED_DATA_SPARE_PARTS(NB_SPARE_PARTS NUMBER) AS
BEGIN
    FOR i IN 1..NB_SPARE_PARTS LOOP
       
    END LOOP;
END;
