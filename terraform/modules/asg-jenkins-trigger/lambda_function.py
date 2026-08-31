import base64
import json
import os
import urllib.parse
import urllib.request


def lambda_handler(event, context):
    print("Received event:")
    print(json.dumps(event))

    jenkins_url = os.environ["JENKINS_URL"].rstrip("/")
    jenkins_job = os.environ["JENKINS_JOB"]
    jenkins_user = os.environ["JENKINS_USER"]
    jenkins_api_token = os.environ["JENKINS_API_TOKEN"]
    image_tag = os.environ.get("IMAGE_TAG", "latest")

    build_url = f"{jenkins_url}/job/{jenkins_job}/buildWithParameters"

    data = urllib.parse.urlencode({
        "IMAGE_TAG": image_tag
    }).encode("utf-8")

    token = base64.b64encode(
        f"{jenkins_user}:{jenkins_api_token}".encode("utf-8")
    ).decode("utf-8")

    request = urllib.request.Request(
        build_url,
        data=data,
        method="POST",
        headers={
            "Authorization": f"Basic {token}",
            "Content-Type": "application/x-www-form-urlencoded"
        }
    )

    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            response_body = response.read().decode("utf-8", errors="ignore")
            print(f"Jenkins response status: {response.status}")
            print(response_body)

            return {
                "statusCode": response.status,
                "body": "Jenkins CD job triggered"
            }

    except Exception as error:
        print(f"Failed to trigger Jenkins: {error}")
        raise