#!/bin/bash
# Prometheus Alert Validation Script
# Validates alert rules using promtool
# Created by: Thanusha Bai V, DevOps

echo "=========================================="
echo "  PROMETHEUS ALERT VALIDATION"
echo "  $(date)"
echo "=========================================="
echo ""

PROMTOOL="/opt/prometheus/promtool"

if [ ! -f "$PROMTOOL" ]; then
    echo "❌ promtool not found at $PROMTOOL"
    echo "Please ensure Prometheus is installed at /opt/prometheus/"
    exit 1
fi

echo "🔍 Validating Original Alerts..."
if [ -f "alerts/original_alerts.yml" ]; then
    $PROMTOOL check rules alerts/original_alerts.yml
    if [ $? -eq 0 ]; then
        echo "✅ Original alerts valid!"
    else
        echo "❌ Original alerts invalid!"
    fi
else
    echo "⚠️  original_alerts.yml not found"
fi

echo ""
echo "🔍 Validating Tuned Alerts..."
if [ -f "alerts/tuned_alerts.yml" ]; then
    $PROMTOOL check rules alerts/tuned_alerts.yml
    if [ $? -eq 0 ]; then
        echo "✅ Tuned alerts valid!"
    else
        echo "❌ Tuned alerts invalid!"
    fi
else
    echo "⚠️  tuned_alerts.yml not found"
fi

echo ""
echo "=========================================="
echo "  VALIDATION COMPLETE"
echo "=========================================="