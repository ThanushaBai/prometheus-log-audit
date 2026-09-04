#!/bin/bash
# Prometheus Alert Rollback Script
# Restores original alert rules in case of issues
# Created by: Thanusha Bai V, DevOps

echo "=========================================="
echo "  PROMETHEUS ALERT ROLLBACK"
echo "  $(date)"
echo "=========================================="
echo ""

echo -n "Continue with rollback? (y/n): "
read CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Rollback cancelled."
    exit 0
fi

echo ""
echo "🔄 Starting rollback process..."

# Step 1: Restore original alerts
echo "  Step 1: Restoring original alerts..."
if [ -f "alerts/original_alerts.yml" ]; then
    sudo cp ~/prometheus-log-audit/alerts/original_alerts.yml /etc/prometheus/alerts/system_alerts.yml 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "    ✅ Original alerts restored"
    else
        echo "    ❌ Failed to restore original alerts"
        exit 1
    fi
else
    echo "    ❌ original_alerts.yml not found"
    exit 1
fi

# Step 2: Validate configuration
echo "  Step 2: Validating configuration..."
/opt/prometheus/promtool check rules /etc/prometheus/alerts/system_alerts.yml 2>/dev/null
if [ $? -eq 0 ]; then
    echo "    ✅ Validation passed"
else
    echo "    ❌ Validation failed"
    exit 1
fi

# Step 3: Reload or restart Prometheus
echo "  Step 3: Reloading Prometheus..."
sudo systemctl reload prometheus 2>/dev/null
if [ $? -eq 0 ]; then
    echo "    ✅ Prometheus reloaded"
else
    echo "    ⚠️  Reload failed, restarting..."
    sudo systemctl restart prometheus
    echo "    ✅ Prometheus restarted"
fi

# Step 4: Verify
echo "  Step 4: Verifying alerts..."
sleep 2
curl -s http://localhost:9090/api/v1/alerts | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    alerts = data.get('data', {}).get('alerts', [])
    print(f'    Total active alerts: {len(alerts)}')
    if len(alerts) == 0:
        print('    ✅ No alerts firing - System healthy!')
except:
    pass
"

echo ""
echo "=========================================="
echo "  ✅ ROLLBACK COMPLETE"
echo "=========================================="