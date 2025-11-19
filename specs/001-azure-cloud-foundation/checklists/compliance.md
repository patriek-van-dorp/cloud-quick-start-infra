# Compliance Requirements Quality Checklist

**Purpose**: Validate the quality, clarity, and completeness of compliance requirements for Azure Cloud Foundation  
**Created**: November 18, 2025  
**Domain**: Compliance  
**Feature**: Azure Cloud Foundation for Toyota Louwmans Financial Services

## Requirement Completeness

- [ ] CHK073 - Are DORA (Digital Operational Resilience Act) requirements specified with concrete ICT risk management controls? [Completeness, DORA Framework]
- [ ] CHK074 - Are SOX (Sarbanes-Oxley) compliance requirements defined with specific financial reporting controls and segregation of duties? [Completeness, Financial Regulations]
- [ ] CHK075 - Are GDPR (General Data Protection Regulation) requirements specified with data residency, processing, and subject rights controls? [Completeness, Spec §FR-011]
- [ ] CHK076 - Are PCI DSS (Payment Card Industry) requirements defined for cardholder data protection and network security? [Completeness, Payment Security]
- [ ] CHK077 - Are audit trail requirements specified with 7-year retention, immutability, and chain of custody controls? [Completeness, Spec §FR-004, §FR-016]
- [ ] CHK078 - Are regulatory reporting requirements defined for AFM/DNB (Netherlands) and EBA (European Banking Authority)? [Completeness, Regulatory Authorities]

## Requirement Clarity

- [ ] CHK079 - Is "FSI compliance" quantified with specific regulatory frameworks, control objectives, and assessment criteria? [Clarity, Spec Compliance Requirements]
- [ ] CHK080 - Are "7-year audit retention" requirements specified with data formats, storage classes, and retrieval procedures? [Clarity, Spec §FR-016]
- [ ] CHK081 - Is "complete isolation from parent company" defined with verifiable separation controls and validation procedures? [Clarity, Spec §FR-015]
- [ ] CHK082 - Are "automated compliance policies" specified with enforcement mechanisms, exceptions, and remediation procedures? [Clarity, Spec §FR-003]
- [ ] CHK083 - Is "real-time compliance monitoring" defined with detection thresholds, alerting criteria, and response timelines? [Clarity, Spec §FR-005]
- [ ] CHK084 - Are "privileged access controls" quantified with specific authentication factors, approval workflows, and session monitoring? [Clarity, Spec §FR-012, §FR-014]

## Requirement Consistency

- [ ] CHK085 - Do data residency requirements align between GDPR Article 44-49 and DORA operational resilience specifications? [Consistency, EU Regulations]
- [ ] CHK086 - Are encryption requirements consistent across SOX financial data and PCI DSS cardholder data specifications? [Consistency, Data Protection]
- [ ] CHK087 - Do audit logging requirements align between regulatory retention periods and operational monitoring needs? [Consistency, Spec §FR-004, §FR-005]
- [ ] CHK088 - Are access control requirements consistent across segregation of duties and least privilege principle specifications? [Consistency, Spec §FR-002, §FR-012]
- [ ] CHK089 - Do incident response requirements align between DORA ICT incidents and general security event handling? [Consistency, DORA vs Security]
- [ ] CHK090 - Are compliance monitoring requirements consistent across automated policy enforcement and manual audit procedures? [Consistency, Automation vs Manual]

## Acceptance Criteria Quality

- [ ] CHK091 - Can DORA ICT risk management framework compliance be objectively measured through automated assessment tools? [Measurability, DORA Framework]
- [ ] CHK092 - Are SOX segregation of duties controls verifiable through role assignment audits and access reviews? [Measurability, SOX Controls]
- [ ] CHK093 - Can GDPR data subject rights compliance be validated through automated data discovery and deletion workflows? [Measurability, GDPR Rights]
- [ ] CHK094 - Are PCI DSS network segmentation controls testable through vulnerability scanning and penetration testing? [Measurability, PCI Security]
- [ ] CHK095 - Can audit trail completeness be verified through log analysis and forensic examination procedures? [Measurability, Audit Requirements]
- [ ] CHK096 - Are compliance policy effectiveness measures defined through violation rates and remediation metrics? [Measurability, Policy Performance]

## Scenario Coverage

- [ ] CHK097 - Are compliance requirements defined for major ICT incident scenarios under DORA Article 19? [Coverage, DORA Incidents]
- [ ] CHK098 - Are requirements specified for cross-border data transfer compliance under GDPR adequate protection decisions? [Coverage, GDPR Transfers]
- [ ] CHK099 - Are compliance requirements defined for third-party vendor management and due diligence under DORA Article 28? [Coverage, DORA Third Parties]
- [ ] CHK100 - Are requirements specified for emergency access scenarios while maintaining SOX segregation controls? [Coverage, Emergency vs Control]
- [ ] CHK101 - Are compliance requirements defined for business continuity scenarios affecting regulatory reporting timelines? [Coverage, Business Continuity]
- [ ] CHK102 - Are requirements specified for compliance during Azure service disruptions and regional outages? [Coverage, Cloud Resilience]

## Edge Case Coverage

- [ ] CHK103 - Are compliance requirements defined for conflicting regulatory obligations between EU and other jurisdictions? [Edge Case, Regulatory Conflicts]
- [ ] CHK104 - Are requirements specified for handling data subject requests during system maintenance or outages? [Edge Case, GDPR vs Availability]
- [ ] CHK105 - Are compliance requirements defined for legacy data migration while maintaining audit trail integrity? [Edge Case, Migration Compliance]
- [ ] CHK106 - Are requirements specified for handling compliance during merger, acquisition, or divestiture scenarios? [Edge Case, Corporate Changes]
- [ ] CHK107 - Are compliance requirements defined for responding to new or changed regulatory interpretations? [Edge Case, Regulatory Evolution]
- [ ] CHK108 - Are requirements specified for maintaining compliance during emergency government access requests? [Edge Case, Government Access]

## Non-Functional Requirements

- [ ] CHK109 - Are compliance performance requirements specified with audit processing times and reporting generation speeds? [Performance, Operational Efficiency]
- [ ] CHK110 - Are compliance scalability requirements defined for growing transaction volumes and user populations? [Scalability, Business Growth]
- [ ] CHK111 - Are compliance availability requirements specified for regulatory reporting systems and audit infrastructure? [Availability, Regulatory Operations]
- [ ] CHK112 - Are compliance maintainability requirements defined for policy updates and regulatory change management? [Maintainability, Regulatory Agility]
- [ ] CHK113 - Are compliance security requirements specified with defense-in-depth for sensitive regulatory data? [Security, Regulatory Data Protection]
- [ ] CHK114 - Are compliance usability requirements defined for auditor interfaces and compliance dashboards? [Usability, Auditor Experience]

## Dependencies & Assumptions

- [ ] CHK115 - Are dependencies on Azure compliance certifications documented with validity periods and renewal requirements? [Dependencies, Azure Compliance]
- [ ] CHK116 - Are assumptions about regulatory interpretation and guidance validated with legal counsel and compliance teams? [Assumptions, Legal Validation]
- [ ] CHK117 - Are dependencies on third-party compliance tools and services documented with SLA requirements? [Dependencies, External Tools]
- [ ] CHK118 - Are assumptions about data classification schemes validated against regulatory definitions and industry standards? [Assumptions, Data Classification]
- [ ] CHK119 - Are dependencies on specific Azure regions documented for compliance jurisdiction and data sovereignty? [Dependencies, Regional Compliance]
- [ ] CHK120 - Are assumptions about audit frequency and scope validated with regulatory authorities and auditors? [Assumptions, Audit Expectations]

## Ambiguities & Conflicts

- [ ] CHK121 - Are potential conflicts between DORA operational resilience testing and business continuity requirements identified? [Conflict, DORA vs Business Ops]
- [ ] CHK122 - Are ambiguities in "financial data" classification clarified for SOX vs. PCI DSS scope boundaries? [Ambiguity, Financial Data Scope]
- [ ] CHK123 - Are conflicts between GDPR right to erasure and regulatory retention requirements explicitly addressed? [Conflict, GDPR vs Retention]
- [ ] CHK124 - Are ambiguities in "major ICT incident" definition clarified for DORA reporting thresholds? [Ambiguity, DORA Incident Scope]
- [ ] CHK125 - Are potential conflicts between automated compliance enforcement and human override requirements identified? [Conflict, Automation vs Control]
- [ ] CHK126 - Are ambiguities in cross-border data transfer adequacy decisions clarified for operational scenarios? [Ambiguity, GDPR Transfers]

## Regulatory Framework Alignment

- [ ] CHK127 - Are DORA ICT risk management requirements aligned with existing enterprise risk management frameworks? [Framework, DORA Integration]
- [ ] CHK128 - Are SOX internal controls aligned with COSO framework and IT general controls requirements? [Framework, SOX ITGC]
- [ ] CHK129 - Are GDPR privacy by design principles aligned with Azure Well-Architected Framework security pillar? [Framework, GDPR by Design]
- [ ] CHK130 - Are PCI DSS requirements aligned with NIST Cybersecurity Framework and ISO 27001 controls? [Framework, PCI Alignment]
- [ ] CHK131 - Are EBA Cloud Guidelines aligned with ENISA cloud security recommendations and best practices? [Framework, EBA Guidelines]
- [ ] CHK132 - Are Netherlands AFM/DNB requirements aligned with Basel III operational risk management principles? [Framework, National Regulators]

## Compliance Monitoring & Reporting

- [ ] CHK133 - Are automated compliance monitoring requirements specified with real-time dashboards and KPI tracking? [Monitoring, Real-time Visibility]
- [ ] CHK134 - Are regulatory reporting requirements defined with standardized formats, submission procedures, and deadlines? [Reporting, Regulatory Submission]
- [ ] CHK135 - Are compliance metrics and KPIs specified with baseline measurements and improvement targets? [Metrics, Performance Management]
- [ ] CHK136 - Are audit trail analysis requirements defined with forensic capabilities and investigation procedures? [Analysis, Forensic Readiness]
- [ ] CHK137 - Are compliance trend analysis requirements specified with predictive capabilities and early warning systems? [Analysis, Predictive Compliance]
- [ ] CHK138 - Are executive compliance reporting requirements defined with board-level summaries and risk indicators? [Reporting, Executive Dashboard]

## Data Protection & Privacy

- [ ] CHK139 - Are GDPR data minimization requirements specified with automated data lifecycle management? [Privacy, Data Minimization]
- [ ] CHK140 - Are data subject rights requirements defined with automated request processing and response procedures? [Privacy, Subject Rights]
- [ ] CHK141 - Are privacy impact assessment requirements specified for new data processing activities? [Privacy, Impact Assessment]
- [ ] CHK142 - Are data breach notification requirements defined with detection, assessment, and reporting timelines? [Privacy, Breach Response]
- [ ] CHK143 - Are consent management requirements specified with granular controls and withdrawal mechanisms? [Privacy, Consent Management]
- [ ] CHK144 - Are data portability requirements defined with standardized export formats and transfer procedures? [Privacy, Data Portability]

## Financial Compliance Controls

- [ ] CHK145 - Are SOX entity-level controls specified with tone at the top and control environment requirements? [SOX, Entity Controls]
- [ ] CHK146 - Are financial reporting controls defined with assertion-level controls and testing procedures? [SOX, Reporting Controls]
- [ ] CHK147 - Are change management controls specified with segregation between development and production? [SOX, Change Controls]
- [ ] CHK148 - Are access controls requirements defined with role-based permissions and regular access reviews? [SOX, Access Controls]
- [ ] CHK149 - Are backup and recovery controls specified with restoration testing and integrity verification? [SOX, Backup Controls]
- [ ] CHK150 - Are monitoring controls requirements defined with exception reporting and management review procedures? [SOX, Monitoring Controls]

## Operational Resilience (DORA)

- [ ] CHK151 - Are ICT risk management requirements specified with governance frameworks and risk appetite statements? [DORA, Risk Management]
- [ ] CHK152 - Are incident management requirements defined with classification, escalation, and resolution procedures? [DORA, Incident Management]
- [ ] CHK153 - Are operational resilience testing requirements specified with threat-led penetration testing programs? [DORA, Resilience Testing]
- [ ] CHK154 - Are third-party ICT service provider requirements defined with due diligence and ongoing monitoring? [DORA, Third Party Risk]
- [ ] CHK155 - Are information sharing requirements specified with threat intelligence and incident reporting? [DORA, Information Sharing]
- [ ] CHK156 - Are digital operational resilience capabilities defined with recovery objectives and continuity planning? [DORA, Business Continuity]

## Audit & Assurance

- [ ] CHK157 - Are internal audit requirements specified with risk-based audit planning and execution procedures? [Audit, Internal Audit]
- [ ] CHK158 - Are external audit requirements defined with auditor access, documentation, and cooperation procedures? [Audit, External Audit]
- [ ] CHK159 - Are regulatory examination requirements specified with preparation, facilitation, and response procedures? [Audit, Regulatory Exam]
- [ ] CHK160 - Are audit evidence requirements defined with documentation standards, retention, and retrieval procedures? [Audit, Evidence Management]
- [ ] CHK161 - Are audit finding management requirements specified with remediation tracking and validation procedures? [Audit, Finding Resolution]
- [ ] CHK162 - Are continuous auditing requirements defined with automated testing and exception monitoring? [Audit, Continuous Monitoring]

## Cross-Border & Jurisdictional

- [ ] CHK163 - Are cross-border data transfer requirements specified with adequacy decisions and appropriate safeguards? [Jurisdiction, Data Transfers]
- [ ] CHK164 - Are local data localization requirements defined with residency controls and processing restrictions? [Jurisdiction, Data Localization]
- [ ] CHK165 - Are regulatory notification requirements specified for cross-border incidents and data breaches? [Jurisdiction, Notification]
- [ ] CHK166 - Are legal framework requirements defined for dispute resolution and regulatory cooperation? [Jurisdiction, Legal Framework]
- [ ] CHK167 - Are tax compliance requirements specified with transfer pricing and digital services considerations? [Jurisdiction, Tax Compliance]
- [ ] CHK168 - Are international sanctions requirements defined with screening and monitoring procedures? [Jurisdiction, Sanctions Compliance]