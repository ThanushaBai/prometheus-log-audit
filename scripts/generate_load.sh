#!/bin/bash
# Generate CPU Load for Testing
# Simulates high CPU usage to test alert triggering

echo "=========================================="
echo "  GENERATING CPU LOAD"
echo "  Duration: 30 seconds"
echo "=========================================="

echo "Generating CPU load..."
for i in {1..4}; do
    (dd if=/dev/zero of=/dev/null &)
done

sleep 30

# Kill background processes
pkill dd 2>/dev/null

echo ""
echo "✅ Load generation complete"
echo ""
echo "Check alerts now:"
echo "  ./scripts/alert_dashboard.sh"
echo "  curl -s http://localhost:9090/api/v1/alerts"
echo ""
echo "=========================================="