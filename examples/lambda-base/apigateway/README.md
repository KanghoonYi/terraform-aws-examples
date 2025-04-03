# apigateway

### Requirement
* Terraform
    * [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
    * [Terrafom standard module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
* AWS CLI
    * [How to set environment variables](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html)
* AWS SAM CLI
    * [Install the AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)

### Local Server 실행 방법
개발 과정에서 Cycle을 줄이기 위해, Local에서 실행할 수 있어야 합니다. 여기서는 그 실행 방법을 안내드립니다.
> 아직 Debugger가 자동으로 붙지는 않습니다. (AWS SAM을 이용해서 terraform을 실행하는 것이기 때문에..)

1. `AWS SAM CLI`를 설치합니다.
    - 이 [link](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)를 참고하여 설치합니다.
2. `Docker Daemon`을 실행합니다.
3. 아래와 같은 명령어를 사용하여 Server를 시작합니다. 그러면, Build 후에 Docker에 Container가 실행됩니다.
```shell
$ npm run local-run:dev
```
4. 이제 Console에 아래와 같은 메세지가 뜹니다.
```shell
Starting the Local Lambda Service. You can now invoke your Lambda Functions defined in your template through the endpoint.                                                                                                                        
2025-03-06 16:46:01 WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://127.0.0.1:3001
2025-03-06 16:46:01 Press CTRL+C to quit
```  
5. '4'의 메세지에 있는 Server URL을 이용해 아래와 같이 TEST요청을 보낼 수 있습니다.(POST method를 사용합니다.)
```shell
curl --location 'http://127.0.0.1:3001/2015-03-31/functions/getHello-prod/invocations' \
--header 'Content-Type: application/json' \
--data '{
  "body": "",
  "resource": "/{proxy+}",
  "path": "/path/to/resource",
  "httpMethod": "POST",
  "isBase64Encoded": true,
  "queryStringParameters": {
  },
  "multiValueQueryStringParameters": {
    "createdAtBegin": [
        "2025-02-24"
    ],
    "createdAtEnd": [
      "2025-03-02"
    ]
  },
  "pathParameters": {
    "proxy": "/path/to/resource"
  },
  "stageVariables": {
    "baz": "qux"
  },
  "headers": {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Accept-Encoding": "gzip, deflate, sdch",
    "Accept-Language": "en-US,en;q=0.8",
    "Cache-Control": "max-age=0",
    "CloudFront-Forwarded-Proto": "https",
    "CloudFront-Is-Desktop-Viewer": "true",
    "CloudFront-Is-Mobile-Viewer": "false",
    "CloudFront-Is-SmartTV-Viewer": "false",
    "CloudFront-Is-Tablet-Viewer": "false",
    "CloudFront-Viewer-Country": "US",
    "Host": "1234567890.execute-api.us-east-1.amazonaws.com",
    "Upgrade-Insecure-Requests": "1",
    "User-Agent": "Custom User Agent String",
    "Via": "1.1 08f323deadbeefa7af34d5feb414ce27.cloudfront.net (CloudFront)",
    "X-Amz-Cf-Id": "cDehVQoZnx43VYQb9j2-nvCh-9z396Uhbp027Y2JvkCPNLmGJHqlaA==",
    "X-Forwarded-For": "127.0.0.1, 127.0.0.2",
    "X-Forwarded-Port": "443",
    "X-Forwarded-Proto": "https"
  },
  "multiValueHeaders": {
    "Accept": [
      "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    ],
    "Accept-Encoding": [
      "gzip, deflate, sdch"
    ],
    "Accept-Language": [
      "en-US,en;q=0.8"
    ],
    "Cache-Control": [
      "max-age=0"
    ],
    "CloudFront-Forwarded-Proto": [
      "https"
    ],
    "CloudFront-Is-Desktop-Viewer": [
      "true"
    ],
    "CloudFront-Is-Mobile-Viewer": [
      "false"
    ],
    "CloudFront-Is-SmartTV-Viewer": [
      "false"
    ],
    "CloudFront-Is-Tablet-Viewer": [
      "false"
    ],
    "CloudFront-Viewer-Country": [
      "US"
    ],
    "Host": [
      "0123456789.execute-api.us-east-1.amazonaws.com"
    ],
    "Upgrade-Insecure-Requests": [
      "1"
    ],
    "User-Agent": [
      "Custom User Agent String"
    ],
    "Via": [
      "1.1 08f323deadbeefa7af34d5feb414ce27.cloudfront.net (CloudFront)"
    ],
    "X-Amz-Cf-Id": [
      "cDehVQoZnx43VYQb9j2-nvCh-9z396Uhbp027Y2JvkCPNLmGJHqlaA=="
    ],
    "X-Forwarded-For": [
      "127.0.0.1, 127.0.0.2"
    ],
    "X-Forwarded-Port": [
      "443"
    ],
    "X-Forwarded-Proto": [
      "https"
    ]
  },
  "requestContext": {
    "accountId": "123456789012",
    "resourceId": "123456",
    "stage": "prod",
    "requestId": "c6af9ac6-7b61-11e6-9a41-93e8deadbeef",
    "requestTime": "09/Apr/2015:12:34:56 +0000",
    "requestTimeEpoch": 1428582896000,
    "identity": {
      "cognitoIdentityPoolId": null,
      "accountId": null,
      "cognitoIdentityId": null,
      "caller": null,
      "accessKey": null,
      "sourceIp": "127.0.0.1",
      "cognitoAuthenticationType": null,
      "cognitoAuthenticationProvider": null,
      "userArn": null,
      "userAgent": "Custom User Agent String",
      "user": null
    },
    "path": "/prod/path/to/resource",
    "resourcePath": "/{proxy+}",
    "httpMethod": "POST",
    "apiId": "1234567890",
    "protocol": "HTTP/1.1"
  }
}'
```
#### 참고 문서
- [terraform-aws-module과 AWS SAM 연동](https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest#sam_cli_integration)
- [AWS 공식 문서](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/terraform-support.html)
- [AWS Blog](https://aws.amazon.com/ko/blogs/compute/better-together-aws-sam-cli-and-hashicorp-terraform/)

### 배포를 위한 세팅 방법
1. 이 [link](https://docs.aws.amazon.com/ko_kr/cli/v1/userguide/cli-configure-files.html)를 활용하여, AWS Connection을 세팅합니다
2. 아래 명령어를 통해, terraform을 init합니다. 이때, `-backend-config=`를 설정하여, stage분리를 사용합니다.
```shell
$ terraform init -backend-config="./vars/backend-dev.tfvars"
```
3. 설정한 AWS CLI config에 따라, 이를 활용하여 terraform을 실행합니다.(여기선 AWS CLI의 Profile방식을 사용합니다)
   이때, stage에 따른 variable을 분기처리하여 사용합니다.
```shell
$ terraform plan -var-file=./vars/dev.tfvars
```

### Dev 배포방법
위의 'Plan' command는 terraform의 실행 계획을 확인하는 방법입니다.  
배포를 진행하려면, 아래와 같은 방법을 사용합니다.
```shell
$ terraform apply -var-file=./vars/dev.tfvars
```

### Production 배포 방법
```shell
$ terraform apply -var-file=./vars/prod.tfvars
```

### API Gateway를 통한 요청 sample
```shell
curl --location 'https://abcd.execute-api.ap-northeast-2.amazonaws.com/dev/get-hello'
```

## References
* [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
    * Terraform에서 사용하는 AWS 스펙을 확인할 수 있습니다
* [Terrafom standard module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
    * 이 repository의 structure를 잡는데 참고하였습니다.