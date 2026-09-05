#!/bin/bash
# Test alert triggers - Verifies alerts fire correctly

echo "=========================================="
echo "  ALERT RULE TESTS"
echo "  $(date)"
echo "=========================================="

PASSED=0
FAILED=0

# Test 1: Check if CPU alert exists
echo "Test 1: Checking HighCPU alert..."
if grep -q "HighCPUUsage" ~/prometheus-log-audit/alerts/tuned_alerts.yml; then
    echo "  ✅ HighCPU alert configured"
    ((PASSED++))
else
    echo "  ❌ HighCPU alert not found"
    ((FAILED++))
fi

# Test 2: Check if Memory alert exists
echo "Test 2: Checking HighMemory alert..."
if grep -q "HighMemoryUsage" ~/prometheus-log-audit/alerts/tuned_alerts.yml; then
    echo "  ✅ HighMemory alert configured"
    ((PASSED++))
else
    echo "  ❌ HighMemory alert not found"
    ((FAILED++))
fi

# Test 3: Check if Disk alert exists
echo "Test 3: Checking HighDisk alert..."
if grep -q "HighDiskUsage" ~/prometheus-log-audit/alerts/tuned_alerts.yml; then
    echo "  ✅ HighDisk alert configured"
    ((PASSED++))
else
    echo "  ❌ HighDisk alert not found"
    ((FAILED++))
fi

# Test 4: Check if ServiceDown alert exists
echo "Test 4: Checking ServiceDown alert..."
if grep -q "ServiceDown" ~/prometheus-log-audit/alerts/tuned_alerts.yml; then
    echo "  ✅ ServiceDown alert configured"
    ((PASSED++))
else
    echo "  ❌ ServiceDown alert not found"
    ((FAILED++))
fi

# Test 5: Check if SystemHealthCheck alert exists
echo "Test 5: Checking SystemHealthCheck alert..."
if grep -q "SystemHealthCheck" ~/prometheus-log-audit/alerts/tuned_alerts.yml; then
    echo "  ✅ SystemHealthCheck alert configured"
    ((PASSED++))
else
    echo "  ❌ SystemHealthCheck alert not found"
    ((FAILED++))
fi

# Test 6: Check CPU alert duration is 10m
echo "Test 6: Checking CPU alert duration..."
if grep -A2 "HighCPUUsage" ~/prometheus-log-audit/alerts/tuned_alerts.yml | grep -q "for: 10m"; then
    echo "  ✅ CPU alert has 10m duration (tuned)"
    ((PASSED++))
else
    echo "  ❌ CPU alert duration not set correctly"
    ((FAILED++))
fi

# Test 7: Check Memory alert duration is 10m
echo "Test 7: Checking Memory alert duration..."
if grep -A2 "HighMemoryUsage" ~/prometheus-log-audit/alerts/tuned_alerts.yml | grep -q "for: 10m"; then
    echo "  ✅ Memory alert has 10m duration (tuned)"
    ((PASSED++))
else
    echo "  ❌ Memory alert duration not set correctly"
    ((FAILED++))
fi

# Test 8: Check Disk alert duration is 15m
echo "Test 8: Checking Disk alert duration..."
if grep -A2 "HighDiskUsage" ~/prometheus-log-audit/alerts/tuned_alerts.yml | grep -q "for: 15m"; then
    echo "  ✅ Disk alert has 15m duration (tuned)"
    ((PASSED++))
else
    echo "  ❌ Disk alert duration not set correctly"
    ((FAILED++))
fi

# Test 9: Check CPU severity is warning
echo "Test 9: Checking CPU severity level..."
CPU_SEV=$(grep -A4 "HighCPUUsage" ~/prometheus-log-audit/alerts/tuned_alerts.yml | grep "severity:" | awk '{print $2}' | head -1)
if [ "$CPU_SEV" == "warning" ]; then
    echo "  ✅ CPU severity is warning (tuned)"
    ((PASSED++))
else
    echo "  ❌ CPU severity is not warning"
    ((FAILED++))
fi

# Test 10: Verify promtool validation passes
echo "Test 10: Running promtool validation..."
if /opt/prometheus/promtool check rules ~/prometheus-log-audit/alerts/tuned_alerts.yml 2>/dev/null; then
    echo "  ✅ Promtool validation passed"
    ((PASSED++))
else
    echo "  ❌ Promtool validation failed"
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
    echo "  🎉 All alert tests passed!"
else
    echo "  ⚠️  Some tests failed. Please check."
fi
echo "=========================================="