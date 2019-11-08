CREATE INDEX score_trainee
ON supervision_report(evaluation);

CREATE INDEX supervisor
ON trainee_doctor(supervisor);