#!/bin/bash
# Quick Alert Dashboard
# Shows real-time alert status

echo "=========================================="
echo "  ALERT DASHBOARD - $(date +"%Y-%m-%d %H:%M:%S")"
echo "=========================================="

curl -s http://localhost:9090/api/v1/alerts 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    alerts = data.get('data', {}).get('alerts', [])
    
    if len(alerts) == 0:
        print('  ✅ NO ACTIVE ALERTS - System is healthy!')
    else:
        print(f'  ⚠️ {len(alerts)} active alert(s):')
        for alert in alerts:
            labels = alert.get('labels', {})
            state = alert.get('state', 'unknown')
            name = labels.get('alertname', 'unknown')
            icon = '🔴' if state == 'firing' else '🟡'
            print(f'    {icon} {name}: {state}')
except:
    print('  ⚠️ Could not fetch alerts')"

echo "=========================================="