#!/bin/sh

PLATFORM=t76x
FTRACE_PATH=/sys/kernel/debug/tracing
FTRACE_CURRENT=$FTRACE_PATH/current_tracer
FTRACE_LOG=$FTRACE_PATH/trace
FTRACE_TRIGGER=$FTRACE_PATH/tracing_on
FTRACE_MARKER=$FTRACE_PATH/trace_marker
FTRACE_FILTER=$FTRACE_PATH/set_ftrace_filter
FTRACE_AVAILABLE=$FTRACE_PATH/available_filter_functions
LOG=ftrace-$PLATFORM.log

# reset and clear stats
echo "nop" >$FTRACE_CURRENT
grep "^kbase" $FTRACE_AVAILABLE|sed '/kbasep_pm_do_gpu_poweroff_callback/ d' >$FTRACE_FILTER
echo "queue_work" >>$FTRACE_FILTER
echo "jd_done_worker" >>$FTRACE_FILTER
echo "function_graph" >$FTRACE_CURRENT
echo "1"  >$FTRACE_TRIGGER
echo "kbase $PLATFORM debug started"|tee $FTRACE_MARKER
cd  bin-$PLATFORM && ./mali_base_defect_tests --test="MIDBASE-1263" &
sleep 30
echo "kbase $PLATFORM debug stopped"|tee $FTRACE_MARKER
echo "0"  >$FTRACE_TRIGGER
sleep 1
kill $!

cat $FTRACE_LOG >$LOG
