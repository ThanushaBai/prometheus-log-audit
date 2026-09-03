#!/bin/bash
# Prometheus Log Audit - Full Analysis Script
# Analyzes 3 months of alert data and identifies noisy alerts
# Created by: Thanusha Bai V, DevOps

LOG_FILE="/tmp/prometheus_3month_audit.log"
AUDIT_SCRIPT="/tmp/generate_audit_logs.py"

echo "=========================================="
echo "  PROMETHEUS LOG AUDIT - FULL ANALYSIS"
echo "  $(date)"
echo "=========================================="
echo ""

# Check if audit data exists, if not generate it
if [ ! -f "$LOG_FILE" ]; then
    echo "📊 Generating audit log data..."
    
    # Check if Python script exists, if not create it
    if [ ! -f "scripts/generate_audit_logs.py" ]; then
        echo "❌ Error: scripts/generate_audit_logs.py not found!"
        exit 1
    fi
    
    python3 scripts/generate_audit_logs.py
    echo ""
fi

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Error: Log file not found!"
    exit 1
fi

# Statistics
TOTAL=$(wc -l < "$LOG_FILE" 2>/dev/null || echo "0")
FIRING=$(grep -c "firing" "$LOG_FILE" 2>/dev/null || echo "0")
RESOLVED=$(grep -c "resolved" "$LOG_FILE" 2>/dev/null || echo "0")

if [ "$TOTAL" -eq "0" ]; then
    echo "❌ No log data found! Please generate audit logs first."
    exit 1
fi

echo "📊 ALERT STATISTICS"
echo "-------------------"
echo "Total events: $TOTAL"
echo "Firing events: $FIRING"
echo "Resolved events: $RESOLVED"
echo "Resolution rate: $((RESOLVED * 100 / TOTAL))%"
echo ""

echo "🔔 TOP 10 NOISIEST ALERTS"
echo "------------------------"
grep "firing" "$LOG_FILE" 2>/dev/null | grep -oP 'alertname=\K[^ ]+' | sort | uniq -c | sort -rn | head -10 | while read count alert; do
    PERCENT=$((count * 100 / FIRING 2>/dev/null || echo "0"))
    printf "  %-15s %5d times (%3d%% of all firings)\n" "$alert" "$count" "$PERCENT"
done
echo ""

echo "🔄 FLAPPING ALERTS DETECTED"
echo "--------------------------"
grep -oP 'alertname=\K[^ ]+' "$LOG_FILE" 2>/dev/null | sort | uniq | while read alert; do
    FIRES=$(grep "firing" "$LOG_FILE" 2>/dev/null | grep -c "alertname=$alert")
    RESOLVES=$(grep "resolved" "$LOG_FILE" 2>/dev/null | grep -c "alertname=$alert")
    if [ "$FIRES" -gt 0 ] && [ "$RESOLVES" -gt 0 ]; then
        RATIO=$((FIRES * 100 / RESOLVES 2>/dev/null || echo "0"))
        if [ "$RATIO" -gt 80 ] && [ "$RATIO" -lt 120 ]; then
            echo "  ⚠️ $alert: $FIRES firings, $RESOLVES resolves (FLAPPING!)"
        fi
    fi
done
echo ""

echo "💡 RECOMMENDATIONS"
echo "-----------------"
TOP_ALERT=$(grep "firing" "$LOG_FILE" 2>/dev/null | grep -oP 'alertname=\K[^ ]+' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')
TOP_COUNT=$(grep "firing" "$LOG_FILE" 2>/dev/null | grep -oP 'alertname=\K[^ ]+' | sort | uniq -c | sort -rn | head -1 | awk '{print $1}')
if [ -n "$TOP_ALERT" ]; then
    echo "1. Top noisy alert: $TOP_ALERT ($TOP_COUNT occurrences)"
    echo "   → Increase 'for' duration from 2m to 10m"
    echo "   → Adjust threshold from 80% to 90%"
    echo ""
fi
echo "2. Consider adding 'keep_firing_for' for flapping alerts"
echo "3. Review severity levels (downgrade warnings)"
echo ""

echo "✅ AUDIT COMPLETE"
echo "=========================================="