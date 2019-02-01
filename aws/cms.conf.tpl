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
            ["worker2.lmio", 26000], ["worker2.lmio", 26001],
            ["worker3.lmio", 26000], ["worker3.lmio", 26001],
            ["worker4.lmio", 26000], ["worker4.lmio", 26001],
            ["worker5.lmio", 26000], ["worker5.lmio", 26001],
            ["worker6.lmio", 26000], ["worker6.lmio", 26001],
            ["worker7.lmio", 26000], ["worker7.lmio", 26001],
            ["worker8.lmio", 26000], ["worker8.lmio", 26001],
            ["worker9.lmio", 26000], ["worker9.lmio", 26001],

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
    "num_proxies_used": 1,
    "max_submission_length": 100000,
    "max_input_length": 5000000,
    "stl_path": "/usr/share/doc/cppreference/",
    "allow_questions": true,
    "admin_listen_address": "",
    "admin_listen_port":    8889,
    "data_management_policy_url": "http://www.lmio.mii.vu.lt/?p=viewarticles&id=38",

    "teacher_listen_address": "",
    "teacher_listen_port":    8890,
    "teacher_active_contests": [1, 2],
    "teacher_contest_urls": ["/jau/", "/vyr/"],
    "teacher_locale": "lt",
    "teacher_login_kind": "district",
    "teacher_allow_impersonate": false,
    "teacher_show_results": false,

    "rankings": [
        "http://rwsuser:RWSPASSWD@rws.lmio:8890",
	"http://rwsuser:RWSPASSWD@rws.lmio:8891",
	"http://rwsuser:RWSPASSWD@rws.lmio:8892"],
    "ranking_contests": [[1], [2], []],
    "https_certfile": null
}
