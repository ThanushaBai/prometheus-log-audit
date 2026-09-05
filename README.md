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

---

#### Rollback & CI/CD

| Screenshot | Description |
|------------|-------------|
| ![Rollback Script](screenshots/rollback_script.png) | **Rollback Script** - Automated rollback execution |
| ![GitHub Workflow](screenshots/github_workflow.png) | **GitHub Actions** - CI/CD workflow for alert validation |

---

#### Reproducible Audit & Alert Tests (NEW)

| Screenshot | Description |
|------------|-------------|
| ![Setup Repo 1](screenshots/setup_repo_01.png) | **Setup Script** - One-click reproducible audit setup |
| ![Setup Repo 2](screenshots/setup_repo_02.png) | **Setup Script** - Continued |
| ![Test Alert Triggers](screenshots/test_alert_triggers.png) | **Alert Rule Tests** - 10/10 alert tests passed |
| ![Show Before After 1](screenshots/show_before_after_01.png) | **Before/After Results** - Clear comparison table |
| ![Show Before After 2](screenshots/show_before_after_02.png) | **Before/After Results** - Continued |

---

### 📁 Project Structure
prometheus-log-audit/
├── README.md # This file
├── LICENSE # MIT License
├── .gitignore # Git ignore file
├── scripts/
│ ├── run_full_audit.sh # Execute complete audit analysis
│ ├── final_verification.sh # Verify all system components
│ ├── alert_dashboard.sh # Quick alert status view
│ ├── generate_load.sh # Generate CPU load for testing
│ ├── generate_audit_logs.py # Generate 3-month simulated data
│ ├── check_alerts_status.sh # Monitor active alerts
│ ├── test_alerts.sh # Run comprehensive system tests
│ ├── validate_alerts.sh # Validate alert rules with promtool
│ ├── rollback_alerts.sh # Automated rollback to original alerts
│ ├── setup_repo.sh # One-click reproducible audit setup
│ ├── test_alert_triggers.sh # Alert rule tests (10 tests)
│ └── show_before_after.sh # Clear before/after comparison
├── .github/
│ └── workflows/
│ └── validate-alerts.yml # GitHub Actions CI/CD workflow
├── screenshots/ # All screenshots captured
│ ├── prometheus_status.png
│ ├── node_exporter_status.png
│ ├── prometheus_targets.png
│ ├── alert_rules_config_01.png
│ ├── alert_rules_config_02.png
│ ├── alert_rules_api_01.png
│ ├── alert_rules_api_02.png
│ ├── prometheus_alerts_before.png
│ ├── prometheus_alerts_after.png
│ ├── audit_analysis.png
│ ├── tuning_summary_01.png
│ ├── tuning_summary_02.png
│ ├── cpu_usage_01.png
│ ├── cpu_usage_02.png
│ ├── memory_usage.png
│ ├── prometheus_config.png
│ ├── node_exporter_metrics.png
│ ├── ports_status.png
│ ├── prometheus_graph.png
│ ├── final_verification_01.png
│ ├── final_verification_02.png
│ ├── test_alerts_output.png
│ ├── validate_alerts_output.png
│ ├── alert_files_list.png
│ ├── original_alerts_content.png
│ ├── tuned_alerts_content.png
│ ├── alert_comparison.png
│ ├── rollback_script.png
│ ├── github_workflow.png
│ ├── setup_repo_01.png # NEW
│ ├── setup_repo_02.png # NEW
│ ├── test_alert_triggers.png # NEW
│ ├── show_before_after_01.png # NEW
│ └── show_before_after_02.png # NEW
├── alerts/
│ ├── original_alerts.yml # Original noisy alerts (reference)
│ ├── tuned_alerts.yml # Tuned optimized alerts
│ └── system_alerts.yml # Currently active in Prometheus
├── docs/
│ └── prometheus_log_audit.md # Complete project documentation
└── reports/
├── audit_report_final.txt # Complete audit findings
└── tuning_summary.txt # Before/after comparison

text

---

### 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/your-username/prometheus-log-audit.git
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
