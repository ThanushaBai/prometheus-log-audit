#!/bin/bash
# Check Active Alerts Status
# Monitors currently firing alerts
# Created by: Thanusha Bai V, DevOps

echo "=========================================="
echo "  ACTIVE ALERTS STATUS"
echo "  $(date)"
echo "=========================================="

ALERTS=$(curl -s http://localhost:9090/api/v1/alerts 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    alerts = data.get('data', {}).get('alerts', [])
    firing = [a for a in alerts if a.get('state') == 'firing']
    pending = [a for a in alerts if a.get('state') == 'pending']
    print(f'{len(firing)}|{len(pending)}')
except:
    print('0|0')
")

FIRING=$(echo $ALERTS | cut -d'|' -f1)
PENDING=$(echo $ALERTS | cut -d'|' -f2)

echo ""
echo "  🔴 Firing: $FIRING"
echo "  🟡 Pending: $PENDING"
echo ""

if [ "$FIRING" -eq 0 ] && [ "$PENDING" -eq 0 ]; then
    echo "✅ No alerts - System is healthy!"
else
    echo "📊 Detailed status:"
    curl -s http://localhost:9090/api/v1/alerts 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for alert in data['data']['alerts']:
        labels = alert.get('labels', {})
        state = alert.get('state', 'unknown')
        name = labels.get('alertname', 'unknown')
        severity = labels.get('severity', 'unknown')
        icon = '🔴' if state == 'firing' else '🟡'
        print(f'  {icon} {name}: {state} (severity: {severity})')
except:
    pass"
fi

echo ""
echo "=========================================="