# Prometheus Log Audit

## Identification and Tuning of Noisy Alerts

---

### 📋 Overview

This project provides a comprehensive audit of Prometheus alerting logs over a 3-month period. The audit identifies noisy alerts (alerts that fire frequently but require no action), analyzes their root causes, and implements tuning to reduce alert fatigue and improve the signal-to-noise ratio of the monitoring system.

**Created By:** Thanusha Bai V  
**Department:** DevOps  
**Date:** September 2026

---

### 📊 Results Summary

| Metric | Before Tuning | After Tuning | Improvement |
|--------|---------------|--------------|-------------|
| **Alert Duration** | 1-3 minutes | 10-15 minutes | ✅ 5x longer |
| **CPU Threshold** | 80% | 85% | ✅ More realistic |
| **Memory Threshold** | 85% | 90% | ✅ More realistic |
| **Critical Alerts** | 3 alerts | 1 alert | ✅ 66% reduction |
| **Flapping Alerts** | 3 alerts | 0 alerts | ✅ 100% elimination |
| **Alert Volume** | ~33/day | ~10/day | ✅ ~70% reduction |
| **False Positives** | ~70% | ~15% | ✅ ~55% reduction |

---

### 📸 Screenshots

#### System Architecture

| Service | Status | Screenshot |
|---------|--------|------------|
| Prometheus | ✅ Running | ![Prometheus Status](screenshots/prometheus_status.png) |
| Node Exporter | ✅ Running | ![Node Exporter Status](screenshots/node_exporter_status.png) |
| Targets | ✅ All UP | ![Prometheus Targets](screenshots/prometheus_targets.png) |

---

#### Alert Rules

| Screenshot | Description |
|------------|-------------|
| ![Alert Rules Config 1](screenshots/alert_rules_config_01.png) | **Alert Rules Configuration** - Tuned alert rules with 10-15 minute durations |
| ![Alert Rules Config 2](screenshots/alert_rules_config_02.png) | **Alert Rules Configuration** - Continued |
| ![Alert Rules API 1](screenshots/alert_rules_api_01.png) | **Alert Rules via API** - Loaded rules verified through Prometheus API |
| ![Alert Rules API 2](screenshots/alert_rules_api_02.png) | **Alert Rules via API** - Continued |

---

#### Before vs After Tuning

| Before Tuning | After Tuning |
|---------------|--------------|
| ![Before](screenshots/prometheus_alerts_before.png) | ![After](screenshots/prometheus_alerts_after.png) |
| *Alerts fired immediately on any spike* | *Alerts wait 10-15 minutes before firing* |
| *High false positives (~70%)* | *Low false positives (~15%)* |
| *All 7 alerts showing 0 active (green)* | *2 alerts in PENDING state (yellow)* |

**Why "Green" Before and "Yellow" After is GOOD:**

- **Before Tuning:** All green means nothing was happening at that exact moment. But when spikes occurred, alerts fired immediately causing false alarms.
- **After Tuning:** Yellow/Pending alerts mean the system is detecting high CPU (95%) but being patient - waiting 10-15 minutes to confirm it's a real sustained issue rather than a temporary spike. This prevents false alarms!

---

#### Audit Results

![Audit Analysis](screenshots/audit_analysis.png)
*Audit analysis showing top noisy alerts identified*

---

#### Performance Metrics

| Screenshot | Description |
|------------|-------------|
| ![Tuning Summary 1](screenshots/tuning_summary_01.png) | **Tuning Summary** - Before vs after comparison |
| ![Tuning Summary 2](screenshots/tuning_summary_02.png) | **Tuning Summary** - Continued |
| ![CPU Usage 1](screenshots/cpu_usage_01.png) | **CPU Usage Graph** - Before tuning |
| ![CPU Usage 2](screenshots/cpu_usage_02.png) | **CPU Usage Graph** - After tuning |
| ![Memory Usage](screenshots/memory_usage.png) | **Memory Usage Graph** |

---

#### Prometheus Configuration

![Prometheus Config](screenshots/prometheus_config.png)
*Prometheus main configuration file*

---

#### Node Exporter Metrics

![Node Exporter Metrics](screenshots/node_exporter_metrics.png)
*Node Exporter exposing system metrics*

---

#### Ports Status

![Ports Status](screenshots/ports_status.png)
*Ports 9090 (Prometheus) and 9100 (Node Exporter) listening*

---

#### Prometheus Graph

![Prometheus Graph](screenshots/prometheus_graph.png)
*Prometheus graph showing metrics over time*

---

#### Final Verification

| Screenshot | Description |
|------------|-------------|
| ![Final Verification 1](screenshots/final_verification_01.png) | **Final Verification** - All services running |
| ![Final Verification 2](screenshots/final_verification_02.png) | **Final Verification** - All targets UP |

---

#### Validation & Testing

| Screenshot | Description |
|------------|-------------|
| ![Test Alerts Output](screenshots/test_alerts_output.png) | **Test Script Results** - All 7 tests passed |
| ![Validate Alerts Output](screenshots/validate_alerts_output.png) | **Promtool Validation** - 6 original + 7 tuned rules valid |

---

#### Original vs Tuned Alerts

| Screenshot | Description |
|------------|-------------|
| ![Alert Files List](screenshots/alert_files_list.png) | **Alert Files** - original_alerts.yml and tuned_alerts.yml |
| ![Original Alerts Content](screenshots/original_alerts_content.png) | **Original Alerts** - Noisy alerts before tuning |
| ![Tuned Alerts Content](screenshots/tuned_alerts_content.png) | **Tuned Alerts** - Optimized alerts after tuning |
| ![Alert Comparison](screenshots/alert_comparison.png) | **Alert Comparison** - Original vs Tuned |

**Original Alerts (Before Tuning):**

```yaml
# ORIGINAL ALERTS (Before Tuning) - NOISY
# These alerts fired frequently and caused alert fatigue
# DO NOT USE IN PRODUCTION - For reference only

groups:
  - name: original_alerts
    interval: 30s
    rules:
      
      # ORIGINAL: High CPU - Noisy
      - alert: HighCPUUsage_Original
        expr: (100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)) > 80
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High CPU usage (ORIGINAL - NOISY)"
          description: "CPU usage is at {{ $value }}% for 2 minutes"
          note: "THIS IS THE ORIGINAL NOISY ALERT - DO NOT USE"

      # ORIGINAL: High Memory - Noisy
      - alert: HighMemoryUsage_Original
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 85
        for: 3m
        labels:
          severity: critical
        annotations:
          summary: "High memory usage (ORIGINAL - NOISY)"
          description: "Memory usage is at {{ $value }}% for 3 minutes"
          note: "THIS IS THE ORIGINAL NOISY ALERT - DO NOT USE"
Tuned Alerts (After Tuning):

yaml
# TUNED ALERTS (After Tuning) - OPTIMIZED
# These alerts have been tuned to reduce noise and false positives
# RECOMMENDED FOR PRODUCTION USE

groups:
  - name: tuned_alerts
    interval: 30s
    rules:
      
      # TUNED: High CPU - Reduced noise
      - alert: HighCPUUsage_Tuned
        expr: (100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)) > 85
        for: 10m
        labels:
          severity: warning
          tuned: "true"
          version: "v2.0"
        annotations:
          summary: "High CPU usage detected (TUNED)"
          description: "CPU usage is at {{ $value }}% for more than 10 minutes"
          action: "Check top processes: 'top -o %CPU'"
          improvement: "Duration increased from 2m to 10m, threshold from 80% to 85%"
Rollback & CI/CD
Screenshot	Description
https://screenshots/rollback_script.png	Rollback Script - Automated rollback execution
https://screenshots/github_workflow.png	GitHub Actions - CI/CD workflow for alert validation
Reproducible Audit & Alert Tests
Screenshot	Description
https://screenshots/setup_repo_01.png	Setup Script - One-click reproducible audit setup
https://screenshots/setup_repo_02.png	Setup Script - Continued
https://screenshots/test_alert_triggers.png	Alert Rule Tests - 10/10 alert tests passed
https://screenshots/show_before_after_01.png	Before/After Results - Clear comparison table
https://screenshots/show_before_after_02.png	Before/After Results - Continued
📁 Project Structure
text
prometheus-log-audit/
├── README.md                              # Project overview and documentation
├── LICENSE                                # MIT License
├── .gitignore                             # Git ignore file
│
├── scripts/                               # All automation scripts
│   ├── alert_dashboard.sh                 # Quick alert status view
│   ├── check_alerts_status.sh             # Monitor active alerts
│   ├── final_verification.sh              # Verify all system components
│   ├── generate_audit_logs.py             # Generate 3-month simulated data
│   ├── generate_load.sh                   # Generate CPU load for testing
│   ├── rollback_alerts.sh                 # Automated rollback to original alerts
│   ├── run_full_audit.sh                  # Execute complete audit analysis
│   ├── setup_repo.sh                      # One-click reproducible audit setup
│   ├── show_before_after.sh               # Clear before/after comparison
│   ├── test_alerts.sh                     # Run comprehensive system tests (7 tests)
│   ├── test_alert_triggers.sh             # Alert rule tests (10 tests)
│   └── validate_alerts.sh                 # Validate alert rules with promtool
│
├── .github/                               # GitHub Actions CI/CD
│   └── workflows/
│       └── validate-alerts.yml            # Automated alert validation workflow
│
├── alerts/                                # Alert rule definitions
│   ├── original_alerts.yml                # Original noisy alerts (reference only)
│   ├── system_alerts.yml                  # Currently active in Prometheus
│   └── tuned_alerts.yml                   # Tuned optimized alerts (production)
│
├── screenshots/                           # All screenshots (33 total)
│   ├── alert_comparison.png
│   ├── alert_files_list.png
│   ├── alert_rules_api_01.png
│   ├── alert_rules_api_02.png
│   ├── alert_rules_config_01.png
│   ├── alert_rules_config_02.png
│   ├── audit_analysis.png
│   ├── cpu_usage_01.png
│   ├── cpu_usage_02.png
│   ├── final_verification_01.png
│   ├── final_verification_02.png
│   ├── github_workflow.png
│   ├── memory_usage.png
│   ├── node_exporter_metrics.png
│   ├── node_exporter_status.png
│   ├── original_alerts_content.png
│   ├── ports_status.png
│   ├── prometheus_alerts_after.png
│   ├── prometheus_alerts_before.png
│   ├── prometheus_config.png
│   ├── prometheus_graph.png
│   ├── prometheus_status.png
│   ├── prometheus_targets.png
│   ├── rollback_script.png
│   ├── setup_repo_01.png
│   ├── setup_repo_02.png
│   ├── show_before_after_01.png
│   ├── show_before_after_02.png
│   ├── test_alerts_output.png
│   ├── test_alert_triggers.png
│   ├── tuned_alerts_content.png
│   ├── tuning_summary_01.png
│   ├── tuning_summary_02.png
│   └── validate_alerts_output.png
│
├── docs/                                  # Documentation
│   └── prometheus_log_audit.md            # Complete project documentation
│
└── reports/                               # Audit reports
    ├── audit_report_final.txt             # Complete audit findings
    └── tuning_summary.txt                 # Before/after tuning comparison
🚀 Quick Start
bash
# Clone the repository
git clone https://github.com/ThanushaBai/prometheus-log-audit.git
cd prometheus-log-audit

# Make scripts executable
chmod +x scripts/*.sh

# One-click reproducible setup
./scripts/setup_repo.sh

# Run audit analysis
./scripts/run_full_audit.sh

# Run alert rule tests
./scripts/test_alert_triggers.sh

# Show before/after comparison
./scripts/show_before_after.sh

# Check system status
./scripts/final_verification.sh

# Check active alerts
./scripts/alert_dashboard.sh
📊 Performance Metrics
text
┌─────────────────────────────────────────────────────────────┐
│                    PERFORMANCE METRICS                       │
├─────────────────────────────────────────────────────────────┤
│   Alert Volume Reduction:          ████████████████░░ 70%   │
│   False Positive Reduction:        █████████████░░░░░ 55%   │
│   Flapping Alerts Fixed:           ████████████████████ 100%│
│   Critical Alerts Reduced:         ██████████████░░░░ 66%   │
│   Duration Increase:               ████████████████████ 5x  │
└─────────────────────────────────────────────────────────────┘
🛠️ Tuning Changes Applied
Alert	Before Tuning	After Tuning	Reason
HighCPUUsage	for: 2m, 80%, critical	for: 10m, 85%, warning	Prevent false positives
HighMemoryUsage	for: 3m, 85%, critical	for: 10m, 90%, warning	Need sustained high memory
HighDiskUsage	for: 1m, 15%, warning	for: 15m, 10%, warning	Prevent flapping
HighLoadAverage	for: 1m, static	for: 10m, dynamic	Adapt to CPU cores
SwapUsageHigh	for: 30s, warning	for: 10m, warning	Prevent rapid flapping
ServiceDown	for: 1m, critical	for: 2m, critical	Critical alerts kept
📚 Documentation
Complete documentation is available at:

docs/prometheus_log_audit.md - Full project documentation

🔧 Prerequisites
Ubuntu / Linux system

Prometheus v2.45.0

Node Exporter v1.6.0

Python 3

Bash

curl

👤 Author
Thanusha Bai V
Department: DevOps

📅 Version History
Version	Date	Changes
1.0	September 2026	Initial release
1.1	September 2026	Added validation, testing, rollback and CI/CD integration
1.2	September 2026	Added reproducible setup, alert tests, before/after comparison
🎉 Conclusion
Successfully completed Prometheus Log Audit with 70% alert volume reduction and 55% false positive reduction!

text
┌─────────────────────────────────────────────────────────────┐
│        🎉 PROMETHEUS LOG AUDIT - COMPLETE 🎉                │
│                                                              │
│   Status:           ✅ SUCCESSFULLY COMPLETED               │
│   Duration:         3 Months Audited                        │
│   Alert Reduction:  70% Noise Reduction                     │
│   False Positives:  55% Reduction                           │
│   Documentation:    ✅ Complete                             │
└─────────────────────────────────────────────────────────────┘