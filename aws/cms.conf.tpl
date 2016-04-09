{
    "temp_dir": "/tmp",
    "backdoor": false,

    "core_services":
    {
        "LogService":        [["centriukas.lmio", 29000]],
        "ResourceService":   [["centriukas.lmio", 28000]],
        "ScoringService":    [["centriukas.lmio", 28500]],
        "Checker":           [["centriukas.lmio", 22000]],
        "EvaluationService": [["centriukas.lmio", 25000]],
        "Worker":            [

            ["worker1.lmio", 26000], ["worker1.lmio", 26001],
            ["worker1.lmio", 26002], ["worker1.lmio", 26003],
            ["worker1.lmio", 26004], ["worker1.lmio", 26005],
            ["worker1.lmio", 26006], ["worker1.lmio", 26007],

            ["worker2.lmio", 26000], ["worker2.lmio", 26001],
            ["worker2.lmio", 26002], ["worker2.lmio", 26003],
            ["worker2.lmio", 26004], ["worker2.lmio", 26005],
            ["worker2.lmio", 26006], ["worker2.lmio", 26007],

            ["worker3.lmio", 26000], ["worker3.lmio", 26001],
            ["worker3.lmio", 26002], ["worker3.lmio", 26003],
            ["worker3.lmio", 26004], ["worker3.lmio", 26005],
            ["worker3.lmio", 26006], ["worker3.lmio", 26007],

            ["worker4.lmio", 26000], ["worker4.lmio", 26001],
            ["worker4.lmio", 26002], ["worker4.lmio", 26003],
            ["worker4.lmio", 26004], ["worker4.lmio", 26005],
            ["worker4.lmio", 26006], ["worker4.lmio", 26007],

            ["worker5.lmio", 26000], ["worker5.lmio", 26001],
            ["worker5.lmio", 26002], ["worker5.lmio", 26003],
            ["worker5.lmio", 26004], ["worker5.lmio", 26005],
            ["worker5.lmio", 26006], ["worker5.lmio", 26007],

            ["worker6.lmio", 26000], ["worker6.lmio", 26001],
            ["worker6.lmio", 26002], ["worker6.lmio", 26003],
            ["worker6.lmio", 26004], ["worker6.lmio", 26005],
            ["worker6.lmio", 26006], ["worker6.lmio", 26007]

        ],
        "ContestWebServer":  [

            ["127.0.0.1", 21000], ["127.0.0.1",  21001], ["127.0.0.1", 21002],
            ["127.0.0.1", 21003], ["127.0.0.1",  21004], ["127.0.0.1", 21005],
            ["127.0.0.1", 21006], ["127.0.0.1",  21007], ["127.0.0.1", 21008],
            ["127.0.0.1", 21009], ["127.0.0.1",  21010], ["127.0.0.1", 21011]

            ],
        "AdminWebServer":    [["centriukas.lmio", 21100]],
        "ProxyService":      [["centriukas.lmio", 28600]],
        "TeacherWebServer":  [["centriukas.lmio", 21200]]

    },

    "other_services": {},

    "database": "postgresql+psycopg2://cmsuser:DBPASSWD@cmsdb.lmio:5432/cmsdb",
    "database_debug": false,
    "twophase_commit": false,
    "keep_sandbox": false,
    "secret_key":             "SECRET_KEY",
    "tornado_debug": false,
    "contest_listen_address": ["", "", "", "", "", "", "", "", "", "", "", ""],
    "contest_listen_port":    [
        9000, 9001, 9002, 9003, 9004, 9005,
        9006, 9007, 9008, 9009, 9010, 9011],
    "cookie_duration": 10800,
    "submit_local_copy":      true,
    "submit_local_copy_path": "%s/submissions/",
    "ip_lock": true,
    "block_hidden_users": false,
    "is_proxy_used": true,
    "max_submission_length": 100000,
    "max_input_length": 5000000,
    "stl_path": "/usr/share/doc/stl-manual/html/",
    "allow_questions": true,
    "admin_listen_address": "",
    "admin_listen_port":    8889,

    "teacher_listen_address": "",
    "teacher_listen_port":    8890,
    "teacher_active_contests": [1, 2],
    "teacher_contest_urls": ["http://jau.cms.lmio.lt", "http://vyr.cms.lmio.lt"],
    "teacher_locale": "lt",

    "rankings": [],
    "https_certfile": null
}
