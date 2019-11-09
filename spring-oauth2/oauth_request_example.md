## request for oauthorized_code
http://localhost:8000/oauth/authorize?client_id=yum&redirect_uri=http
://localhost:9000/callback&response_type=code&scope=read_profile
> without client_secrit specified


## request for token
curl -X POST --user yum:123456 http://localhost:8000/oauth/token -H "content-type: application/x-www-form-urlencoded" -d "code=fv0jU4&grant_type=authorization_code&redirect_uri=http://localhost:9000/callback&scope=read_profile"
> --user means client_id/client_secret
> 

curl -X GET  http://localhost:8000/api/profile -H "authorization: Bearer 8f6cf585-8bb0-4641-aa09-82008fcbbde2"

09499e13-3490-4fe9-b273-6a14381fb75f
09499e13-3490-4fe9-b273-6a14381fb75f
09499e13-3490-4fe9-b273-6a14381fb75f


curl -X POST --user yum:123456 http://localhost:8000/oauth/token -H "accept: application/json" -H "content-type: application/x-www-form-urlencoded" -d "grant_type=password&username=cmwin&password=manager&scope=read_profile"

curl -X GET http://localhost:8000/api/profile -H "authorization: Bearer 4f912f3a-0b5d-493c-92df-8fbf374003e8"


curl -X POST --user yum:123456 http://localhost:8000/oauth/token -H "content-type:application/x-www-form-urlencoded" -d "grant_type=refresh_token&refresh_token=09499e13-3490-4fe9-b273-6a14381fb75f&scope=read_profile"