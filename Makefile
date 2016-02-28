PROJECT = stumana
DEPS = tuah sync cowboy erlydtl jsx lager cowlib ranch bson pbkdf2 mongodb srly qdate

dep_tuah = git https://github.com/mhishami/tuah.git master
dep_mongodb = git https://github.com/comtihon/mongodb-erlang.git master
dep_pbkdf2 = git https://github.com/basho/erlang-pbkdf2.git 2.0.0
dep_srly = git https://github.com/msantos/srly.git master

include erlang.mk
