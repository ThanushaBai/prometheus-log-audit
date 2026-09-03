#!/bin/bash
# Final Verification Script
# Verifies all system components are working correctly

echo "=========================================="
echo "  FINAL VERIFICATION - ALL COMPONENTS"
echo "  $(date)"
echo "=========================================="

echo ""
echo "📌 SERVICES STATUS:"
echo "  Prometheus: $(sudo systemctl is-active prometheus)"
echo "  Node Exporter: $(sudo systemctl is-active node_exporter)"

echo ""
echo "📌 PORTS:"
sudo ss -tlnp | grep -E "9090|9100" | awk '{print "  " $4}'

echo ""
echo "📌 PROMETHEUS TARGETS:"
curl -s http://localhost:9090/api/v1/targets 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for target in data['data']['activeTargets']:
        job = target['labels'].get('job', 'unknown')
        health = target['health']
        status = '✅' if health == 'up' else '❌'
        print(f'  {status} {job}: {health}')
except:
    print('  ⚠️ Could not fetch targets')"

echo ""
echo "📌 ACTIVE ALERTS:"
curl -s http://localhost:9090/api/v1/alerts 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    alerts = data.get('data', {}).get('alerts', [])
    if not alerts:
        print('  ✅ No active alerts - System is healthy!')
    else:
        print(f'  ⚠️ {len(alerts)} active alert(s)')
except:
    print('  ⚠️ Could not fetch alerts')"

echo ""
echo "=========================================="
echo "  ✅ VERIFICATION COMPLETE"
echo "=========================================="