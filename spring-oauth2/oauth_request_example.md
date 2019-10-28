## request for oauthorized_code
http://localhost:8000/oauth/authorize?client_id=yum&redirect_uri=http
://localhost:9000/callback&response_type=code&scope=read_profile
> without client_secrit specified


## request for token
curl -X POST --user yum:123456 http://localhost:8000/oauth/token -H "content-type: application/x-www-form-urlencoded" -d "code=nTLsQP&grant_type=authorization_code&redirect_uri=http://localhost:9000/callback&scope=read_profile&client_id=yum"
> --user means client_id/client_secret