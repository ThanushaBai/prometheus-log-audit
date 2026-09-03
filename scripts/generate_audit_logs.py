#!/usr/bin/env python3
# Generate 3 months of simulated alert data for audit

import random
from datetime import datetime, timedelta

alerts = {
    'HighCPUUsage': {'prob': 35, 'severity': 'critical'},
    'HighMemoryUsage': {'prob': 25, 'severity': 'critical'},
    'HighDiskUsage': {'prob': 15, 'severity': 'warning'},
    'HighLoadAverage': {'prob': 15, 'severity': 'warning'},
    'SwapUsageHigh': {'prob': 8, 'severity': 'warning'},
    'ServiceDown': {'prob': 2, 'severity': 'critical'},
}

end_date = datetime.now()
total_entries = 3000
log_entries = []

print(f"Generating {total_entries} alert events...")

for i in range(total_entries):
    days_ago = random.randint(0, 89)
    hours_ago = random.randint(0, 23)
    minutes_ago = random.randint(0, 59)
    timestamp = end_date - timedelta(days=days_ago, hours=hours_ago, minutes=minutes_ago)
    
    rand = random.randint(1, 100)
    cumulative = 0
    selected_alert = 'HighCPUUsage'
    for alert, config in alerts.items():
        cumulative += config['prob']
        if rand <= cumulative:
            selected_alert = alert
            break
    
    if random.random() < 0.7:
        value = random.randint(75, 95)
        severity = alerts[selected_alert]['severity']
        log_entry = f'level=info ts="{timestamp}" msg="Alert firing" alertname={selected_alert} severity={severity} value={value}%'
    else:
        log_entry = f'level=info ts="{timestamp}" msg="Alert resolved" alertname={selected_alert}'
    
    log_entries.append(log_entry)

with open('/tmp/prometheus_3month_audit.log', 'w') as f:
    f.write('\n'.join(log_entries))

print(f"✅ Generated {len(log_entries)} alert entries")