#!/bin/bash
# Setup script for Prometheus Log Audit
# Makes the audit reproducible by setting up everything automatically

echo "=========================================="
echo "  PROMETHEUS LOG AUDIT - SETUP"
echo "  $(date)"
echo "=========================================="

echo ""
echo "Step 1: Checking Prometheus..."
if sudo systemctl is-active --quiet prometheus; then
    echo "  ✅ Prometheus is running"
else
    echo "  ❌ Prometheus is not running"
    echo "  Please start Prometheus first"
    exit 1
fi

echo ""
echo "Step 2: Checking Node Exporter..."
if sudo systemctl is-active --quiet node_exporter; then
    echo "  ✅ Node Exporter is running"
else
    echo "  ⚠️ Node Exporter is not running"
fi

echo ""
echo "Step 3: Making scripts executable..."
chmod +x scripts/*.sh
echo "  ✅ All scripts made executable"

echo ""
echo "Step 4: Validating alert rules..."
./scripts/validate_alerts.sh

echo ""
echo "Step 5: Running tests..."
./scripts/test_alerts.sh

echo ""
echo "=========================================="
echo "  ✅ SETUP COMPLETE!"
echo "  Reproducible audit is ready"
echo "=========================================="