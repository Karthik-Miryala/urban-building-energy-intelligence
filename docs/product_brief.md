# Urban Building Energy Intelligence — MVP Product Brief

## 1. Problem

Facility managers cannot easily distinguish normal changes in building energy use from avoidable waste, scheduling problems, and equipment faults.

This project will forecast expected electricity consumption and identify deviations that may deserve investigation.

## 2. Primary user

The primary user is a facility or energy manager responsible for a portfolio of commercial buildings.

## 3. Decisions supported

The system will help the user decide:

1. Which buildings require attention?
2. When did abnormal consumption begin?
3. How large and persistent is the deviation?
4. What may be causing it?
5. What is the estimated financial impact?

## 4. Initial project scope

The first version will use:

- Dataset: Building Data Genome Project 2
- Meter type: Electricity
- Data frequency: Hourly
- Initial portfolio: Up to 25 buildings with sufficiently complete electricity data
- Forecast horizon: The next 24 hourly observations
- Forecast frequency: Once per day
- Forecast origin: 00:00 local building time
- Modeling approach: One global model trained across the selected buildings
- Storage format: Parquet
- Application: Streamlit
- Experiment tracking: MLflow

The building-selection procedure will be deterministic and documented after the data has been profiled. Buildings will not be selected based on which ones produce the best model results.

## 5. Forecasting contract

At forecast time \(t\), the model will predict electricity consumption for hours \(t+1\) through \(t+24\).

A feature is allowed only if its value would genuinely be known at time \(t\).

Observed future electricity consumption must never be used as an input.

Observed future weather from the historical dataset will not initially be treated as if it were a real weather forecast. The first leakage-safe model will use calendar information, historical consumption, and weather information available at or before the forecast origin. Future work may add genuine weather forecasts or an explicitly labeled oracle-weather experiment.

## 6. Initial outputs

For each building and forecasted hour, the system will produce:

- Expected electricity consumption
- Lower prediction bound
- Upper prediction bound
- Actual consumption when it becomes available
- Forecast residual
- Anomaly status
- Estimated excess energy
- Estimated excess cost
- Anomaly priority score
- Short explanation of important contributing factors

## 7. Initial anomaly definition

An observation becomes an anomaly candidate when actual consumption exceeds the upper prediction bound or falls below the lower prediction bound.

A facility-manager alert will normally require the anomaly to persist for at least two consecutive hours.

High-consumption anomalies will receive an initial estimated excess-energy value:

\[
\text{excess\_kwh} = \max(0,\ \text{actual\_kwh} - \text{upper\_bound\_kwh})
\]

Estimated cost will be:

\[
\text{estimated\_cost} = \text{excess\_kwh} \times \text{electricity\_price\_per\_kwh}
\]

The initial electricity price will be configurable and clearly labeled as an assumption.

The final priority score will later combine:

- Uncertainty-adjusted forecast error
- Duration
- Estimated cost
- Confidence
- Data-quality penalties

## 8. Technical success criteria

The first complete version should:

- Beat the seasonal-naive forecast on portfolio-level MAE
- Report results separately for every building
- Use chronological rolling-origin validation
- Keep a final chronological test period untouched during model selection
- Produce prediction intervals with measured empirical coverage
- Avoid features containing information unavailable at forecast time
- Reproduce processed data and model results from documented commands
- Pass automated tests for temporal features and leakage prevention

## 9. Operational success criteria

The application should allow a facility manager to:

- View tomorrow’s expected load profile
- Identify the buildings with the highest-priority anomalies
- Understand the approximate size, duration, and cost of an anomaly
- Inspect likely contributing factors
- Download a simple anomaly report

## 10. Out of scope for the first version

The initial version will not include:

- Every building in the dataset
- Every meter type
- Real-time streaming
- Automated equipment control
- Causal fault diagnosis
- Production cloud deployment
- Guaranteed financial savings
- Genuine weather forecasts unless a separate forecast source is introduced

These capabilities may be added only after the electricity-only pipeline works end to end.