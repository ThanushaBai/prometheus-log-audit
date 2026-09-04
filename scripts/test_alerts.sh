#!/bin/bash
# Prometheus Alert System Tests
# Validates all system components and alert rules
# Created by: Thanusha Bai V, DevOps

echo "=========================================="
echo "  PROMETHEUS ALERT SYSTEM TESTS"
echo "  $(date)"
echo "=========================================="
echo ""

PASSED=0
FAILED=0

echo "Test 1: Checking Prometheus status..."
if sudo systemctl is-active --quiet prometheus; then
    echo "  ✅ Prometheus is running"
    ((PASSED++))
else
    echo "  ❌ Prometheus is not running"
    ((FAILED++))
fi

echo "Test 2: Checking Node Exporter status..."
if sudo systemctl is-active --quiet node_exporter; then
    echo "  ✅ Node Exporter is running"
    ((PASSED++))
else
    echo "  ❌ Node Exporter is not running"
    ((FAILED++))
fi

echo "Test 3: Checking Prometheus port 9090..."
if sudo ss -tlnp | grep -q ":9090"; then
    echo "  ✅ Port 9090 is listening"
    ((PASSED++))
else
    echo "  ❌ Port 9090 is not listening"
    ((FAILED++))
fi

echo "Test 4: Checking Node Exporter port 9100..."
if sudo ss -tlnp | grep -q ":9100"; then
    echo "  ✅ Port 9100 is listening"
    ((PASSED++))
else
    echo "  ❌ Port 9100 is not listening"
    ((FAILED++))
fi

echo "Test 5: Checking Prometheus API..."
if curl -s http://localhost:9090/api/v1/status/config > /dev/null; then
    echo "  ✅ Prometheus API is accessible"
    ((PASSED++))
else
    echo "  ❌ Prometheus API is not accessible"
    ((FAILED++))
fi

echo "Test 6: Checking if alert rules are loaded..."
RULES_COUNT=$(curl -s http://localhost:9090/api/v1/rules 2>/dev/null | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data['data']['groups']))" 2>/dev/null || echo "0")
if [ "$RULES_COUNT" -gt 0 ]; then
    echo "  ✅ Found $RULES_COUNT alert groups loaded"
    ((PASSED++))
else
    echo "  ❌ No alert groups found"
    ((FAILED++))
fi

echo "Test 7: Checking if metrics are available..."
METRICS_COUNT=$(curl -s "http://localhost:9090/api/v1/query?query=up" 2>/dev/null | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data['data']['result']))" 2>/dev/null || echo "0")
if [ "$METRICS_COUNT" -gt 0 ]; then
    echo "  ✅ Metrics are available ($METRICS_COUNT targets)"
    ((PASSED++))
else
    echo "  ❌ No metrics found"
    ((FAILED++))
fi

echo ""
echo "=========================================="
echo "  TEST SUMMARY"
echo "=========================================="
echo "  ✅ Passed: $PASSED"
echo "  ❌ Failed: $FAILED"
echo ""
if [ $FAILED -eq 0 ]; then
    echo "  🎉 All tests passed! System is healthy."
else
    echo "  ⚠️  Some tests failed. Please check the output above."
fi
echo "=========================================="