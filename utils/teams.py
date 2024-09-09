from datetime import datetime
import logging
import requests


def failure_alert_teams(webhook_token, context):
    dag_id = context['task_instance'].dag_id
    task_id = context['task_instance'].task_id
    task_log_url = context['task_instance'].log_url
    execution_date =  context['ts']
    error_message = context.get('exception', 'No error message available.')

   
    message = {
        "@type": "MessageCard",
        "@context": "<http://schema.org/extensions>",
        "themeColor": "FF0000",
        "title": f" {dag_id} task failed.",
        "text": f"""Task {task_id} in DAG {dag_id} has failed. 
        Execution Date: {execution_date}
        Time of Error: {datetime.now().strftime("%m/%d/%Y, %H:%M:%S")}
        Error Message: {error_message}  
        [Task Log]({task_log_url})"""
    }

    response = requests.post(
        webhook_token,
        json=message,
        timeout=300
    )

    if response.status_code == 200:
        logging.info("Failure alert sent to Microsoft Teams.")
    else:
        logging.error(f"Failed to send failure alert. Response code: {response.status_code}")