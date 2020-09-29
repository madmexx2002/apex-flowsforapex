-- Generated by Oracle SQL Developer Data Modeler 20.2.0.167.1538
--   at:        2020-09-29 10:41:45 CEST
--   site:      Oracle Database 12cR2
--   type:      Oracle Database 12cR2



-- predefined type, no DDL - SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE flow_connections (
    conn_id           NUMBER
        GENERATED BY DEFAULT AS IDENTITY ( START WITH 1 CACHE 20 )
    NOT NULL,
    conn_bpmn_id      VARCHAR2(50 CHAR) NOT NULL,
    conn_dgrm_id      NUMBER NOT NULL,
    conn_name         VARCHAR2(200 CHAR),
    conn_src_objt_id  NUMBER,
    conn_tgt_objt_id  NUMBER,
    conn_tag_name     VARCHAR2(50 CHAR),
    conn_origin       VARCHAR2(50 CHAR)
);

ALTER TABLE flow_connections ADD CONSTRAINT conn_pk PRIMARY KEY ( conn_id );

ALTER TABLE flow_connections ADD CONSTRAINT conn_uk UNIQUE ( conn_dgrm_id,
                                                             conn_bpmn_id );

CREATE TABLE flow_diagrams (
    dgrm_id       NUMBER
        GENERATED BY DEFAULT AS IDENTITY ( START WITH 1 NOCACHE )
    NOT NULL,
    dgrm_name     VARCHAR2(150 CHAR) NOT NULL,
    dgrm_content  CLOB
);

ALTER TABLE flow_diagrams ADD CONSTRAINT dgrm_pk PRIMARY KEY ( dgrm_id );

ALTER TABLE flow_diagrams ADD CONSTRAINT dgrm_uk UNIQUE ( dgrm_name );

CREATE TABLE flow_object_attributes (
    obat_objt_id     NUMBER NOT NULL,
    obat_key         VARCHAR2(50 CHAR) NOT NULL,
    obat_num_value   NUMBER,
    obat_date_value  DATE,
    obat_vc_value    VARCHAR2(4000 CHAR),
    obat_clob_value  CLOB,
    CONSTRAINT obat_pk PRIMARY KEY ( obat_objt_id,
                                     obat_key )
)
ORGANIZATION INDEX;

ALTER TABLE flow_object_attributes
    ADD CONSTRAINT obat_ck CHECK ( ( obat_num_value IS NOT NULL
                                     AND obat_date_value IS NULL
                                     AND obat_vc_value IS NULL
                                     AND obat_clob_value IS NULL )
                                   OR ( obat_num_value IS NULL
                                        AND obat_date_value IS NOT NULL
                                        AND obat_vc_value IS NULL
                                        AND obat_clob_value IS NULL )
                                   OR ( obat_num_value IS NULL
                                        AND obat_date_value IS NULL
                                        AND obat_vc_value IS NOT NULL
                                        AND obat_clob_value IS NULL )
                                   OR ( obat_num_value IS NULL
                                        AND obat_date_value IS NULL
                                        AND obat_vc_value IS NULL
                                        AND obat_clob_value IS NOT NULL ) );

CREATE TABLE flow_objects (
    objt_id            NUMBER
        GENERATED BY DEFAULT AS IDENTITY ( START WITH 1 CACHE 20 )
    NOT NULL,
    objt_bpmn_id       VARCHAR2(50 CHAR) NOT NULL,
    objt_dgrm_id       NUMBER NOT NULL,
    objt_name          VARCHAR2(200 CHAR),
    objt_tag_name      VARCHAR2(50 CHAR),
    objt_sub_tag_name  VARCHAR2(50 CHAR),
    objt_objt_id       NUMBER,
    objt_objt_lane_id  NUMBER
);

COMMENT ON COLUMN flow_objects.objt_objt_lane_id IS
    'Reference to Lane if any.';

ALTER TABLE flow_objects ADD CONSTRAINT objt_pk PRIMARY KEY ( objt_id );

ALTER TABLE flow_objects ADD CONSTRAINT objt_uk UNIQUE ( objt_dgrm_id,
                                                         objt_bpmn_id );

CREATE TABLE flow_processes (
    prcs_id           NUMBER
        GENERATED ALWAYS AS IDENTITY ( START WITH 1 NOCACHE )
    NOT NULL,
    prcs_dgrm_id      NUMBER NOT NULL,
    prcs_name         VARCHAR2(150 CHAR) NOT NULL,
    prcs_status       VARCHAR2(20 CHAR) NOT NULL,
    prcs_init_ts      TIMESTAMP WITH TIME ZONE NOT NULL,
    prcs_last_update  TIMESTAMP WITH TIME ZONE
);

ALTER TABLE flow_processes ADD CONSTRAINT prcs_pk PRIMARY KEY ( prcs_id );

CREATE TABLE flow_subflow_log (
    sflg_prcs_id       NUMBER NOT NULL,
    sflg_objt_id       VARCHAR2(50) NOT NULL,
    sflg_sbfl_id       NUMBER NOT NULL,
    sflg_last_updated  DATE,
    sflg_notes         VARCHAR2(200)
);

CREATE TABLE flow_subflows (
    sbfl_id               NUMBER
        GENERATED ALWAYS AS IDENTITY ( START WITH 1 NOCACHE )
    NOT NULL,
    sbfl_prcs_id          NUMBER NOT NULL,
    sbfl_sbfl_id          NUMBER,
    sbfl_starting_object  VARCHAR2(50 CHAR),
    sbfl_route            VARCHAR2(100 CHAR),
    sbfl_last_completed   VARCHAR2(50 CHAR),
    sbfl_current          VARCHAR2(50 CHAR),
    sbfl_status           VARCHAR2(20 CHAR),
    sbfl_last_update      TIMESTAMP WITH TIME ZONE NOT NULL
);

ALTER TABLE flow_subflows ADD CONSTRAINT sbfl_pk PRIMARY KEY ( sbfl_id );

CREATE TABLE flow_timers (
    timr_id            NUMBER
        GENERATED BY DEFAULT AS IDENTITY ( START WITH 1 NOCACHE ORDER )
    NOT NULL,
    timr_prcs_id       NUMBER NOT NULL,
    timr_sbfl_id       NUMBER NOT NULL,
    timr_type          VARCHAR2(50 CHAR) NOT NULL,
    timr_last_run      TIMESTAMP WITH TIME ZONE,
    timr_run_count     NUMBER DEFAULT 0 NOT NULL,
    timr_created_on    TIMESTAMP WITH TIME ZONE NOT NULL,
    timr_status        VARCHAR2(1 CHAR) NOT NULL,
    timr_start_on      TIMESTAMP WITH TIME ZONE,
    timr_interval_ym   INTERVAL YEAR TO MONTH,
    timr_interval_ds   INTERVAL DAY TO SECOND,
    timr_repeat_times  NUMBER
);

COMMENT ON COLUMN flow_timers.timr_status IS
    'Stauts of the timer. For the status codes see constant definitions in FLOW_TIMERS_PKG package declaration.';

COMMENT ON COLUMN flow_timers.timr_start_on IS
    'Expected start datetime.
Used for both date and duration definitions.';

COMMENT ON COLUMN flow_timers.timr_interval_ym IS
    'Interval YM for cycles.';

COMMENT ON COLUMN flow_timers.timr_interval_ds IS
    'Interval DS for cycles.';

COMMENT ON COLUMN flow_timers.timr_repeat_times IS
    'Number of runs for cycles.';

CREATE INDEX timr_prcs_sbfl_ix ON
    flow_timers (
        timr_prcs_id
    ASC,
        timr_sbfl_id
    ASC );

ALTER TABLE flow_timers ADD CONSTRAINT timr_pk PRIMARY KEY ( timr_id );

ALTER TABLE flow_connections
    ADD CONSTRAINT conn_dgrm_fk FOREIGN KEY ( conn_dgrm_id )
        REFERENCES flow_diagrams ( dgrm_id )
            ON DELETE CASCADE;

ALTER TABLE flow_connections
    ADD CONSTRAINT conn_src_objt_fk FOREIGN KEY ( conn_src_objt_id )
        REFERENCES flow_objects ( objt_id )
            ON DELETE SET NULL;

ALTER TABLE flow_connections
    ADD CONSTRAINT conn_tgt_objt_fk FOREIGN KEY ( conn_tgt_objt_id )
        REFERENCES flow_objects ( objt_id )
            ON DELETE SET NULL;

ALTER TABLE flow_object_attributes
    ADD CONSTRAINT obat_objt_fk FOREIGN KEY ( obat_objt_id )
        REFERENCES flow_objects ( objt_id )
            ON DELETE CASCADE;

ALTER TABLE flow_objects
    ADD CONSTRAINT objt_dgrm_fk FOREIGN KEY ( objt_dgrm_id )
        REFERENCES flow_diagrams ( dgrm_id )
            ON DELETE CASCADE;

ALTER TABLE flow_objects
    ADD CONSTRAINT objt_objt_fk FOREIGN KEY ( objt_objt_id )
        REFERENCES flow_objects ( objt_id )
            ON DELETE CASCADE;

ALTER TABLE flow_objects
    ADD CONSTRAINT objt_objt_lane_fk FOREIGN KEY ( objt_objt_lane_id )
        REFERENCES flow_objects ( objt_id )
            ON DELETE SET NULL;

ALTER TABLE flow_processes
    ADD CONSTRAINT prcs_dgrm_fk FOREIGN KEY ( prcs_dgrm_id )
        REFERENCES flow_diagrams ( dgrm_id )
            ON DELETE CASCADE;

ALTER TABLE flow_subflows
    ADD CONSTRAINT sbfl_parent_sbfl_fk FOREIGN KEY ( sbfl_sbfl_id )
        REFERENCES flow_subflows ( sbfl_id )
            ON DELETE CASCADE;

ALTER TABLE flow_subflows
    ADD CONSTRAINT sbfl_prcs_fk FOREIGN KEY ( sbfl_prcs_id )
        REFERENCES flow_processes ( prcs_id )
            ON DELETE CASCADE;

ALTER TABLE flow_timers
    ADD CONSTRAINT timr_prcs_fk FOREIGN KEY ( timr_prcs_id )
        REFERENCES flow_processes ( prcs_id )
            ON DELETE CASCADE;

ALTER TABLE flow_timers
    ADD CONSTRAINT timr_sbfl_fk FOREIGN KEY ( timr_sbfl_id )
        REFERENCES flow_subflows ( sbfl_id )
            ON DELETE CASCADE;



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             8
-- CREATE INDEX                             1
-- ALTER TABLE                             23
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

-- Additional Objects not yet engineered in data modeler

create table flow_process_variables
( prov_prcs_id number not null
, prov_var_name varchar2(50) not null
, prov_var_type varchar2(50) 
, prov_var_vc2 varchar2(200)
, prov_var_num number
, prov_var_date date
, prov_var_clob clob
);

alter table flow_process_variables add constraint prov_pk primary key (prov_prcs_id, prov_var_name);
