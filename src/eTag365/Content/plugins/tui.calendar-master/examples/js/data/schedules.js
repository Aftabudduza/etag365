'use strict';

/*eslint-disable*/

var ScheduleList = [];

var SCHEDULE_CATEGORY = [
    'milestone',
    'task'
];

function ScheduleInfo() {
    this.id = null;
    this.calendarId = null;

    this.title = null;
    this.body = null;
    this.isAllday = false;
    this.start = null;
    this.end = null;
    this.category = '';
    this.dueDateClass = '';

    this.color = null;
    this.bgColor = null;
    this.dragBgColor = null;
    this.borderColor = null;
    this.customStyle = '';

    this.isFocused = false;
    this.isPending = false;
    this.isVisible = true;
    this.isReadOnly = false;
    this.goingDuration = 0;
    this.comingDuration = 0;
    this.recurrenceRule = '';

    this.raw = {
        memo: '',
        hasToOrCc: false,
        hasRecurrenceRule: false,
        location: null,
        class: 'public', // or 'private'
        creator: {
            name: '',
            avatar: '',
            company: '',
            email: '',
            phone: ''
        }
    };
}

function generateTime(schedule, renderStart, renderEnd) {
    var baseDate = new Date(renderStart);
    var singleday = chance.bool({likelihood: 70});
    var startDate = moment(renderStart.getTime());
    var endDate = moment(renderEnd.getTime());
    var diffDate = endDate.diff(startDate, 'days');
    
    schedule.isAllday = true;//chance.bool({likelihood: 30});
    if (schedule.isAllday) {
        schedule.category = 'allday';
    }
   
        schedule.category = SCHEDULE_CATEGORY[chance.integer({min: 0, max: 1})];
        if (schedule.category === SCHEDULE_CATEGORY[1]) {
            schedule.dueDateClass = 'morning';
        }
    
        schedule.category = 'time';
    
    //schedule.dueDateClass = 'morning';
    //schedule.category = 'time';
    //  startDate.add(chance.integer({min: 0, max: diffDate}), 'days');
    //startDate.hours(chance.integer({ min: 0, max: 23 }));
    //startDate.minutes(chance.bool() ? 0 : 30);
    schedule.start = startDate.toDate();

    endDate = moment(endDate);
    //if (schedule.isAllday) {
    //    endDate.add(chance.integer({min: 0, max: 3}), 'days');
    //}

    schedule.end = endDate.toDate();

    //if (!schedule.isAllday && chance.bool({likelihood: 20})) {
    //    schedule.goingDuration = chance.integer({min: 30, max: 120});
    //    schedule.comingDuration = chance.integer({min: 30, max: 120});;

    //    if (chance.bool({likelihood: 50})) {
    //        schedule.end = schedule.start;
    //    }
    //}
}

function generateRandomSchedule(calendar, renderStart, renderEnd,result) {
    var schedule = new ScheduleInfo();
    schedule.id = chance.guid();
    
    schedule.calendarId = result.Id;// calendar.id;
    schedule.title = result.Title;//chance.sentence({words: 3});
    schedule.body = result.Description;//chance.bool({ likelihood: 20 }) ? chance.sentence({ words: 10 }) : '';
    //schedule.title = result.Title;//chance.sentence({words: 3});
    //schedule.body = result.Description;//chance.bool({ likelihood: 20 }) ? chance.sentence({ words: 10 }) : '';
    //schedule.isReadOnly = false;// chance.bool({likelihood: 20});
    //generateTime(schedule, renderStart, renderEnd);
    var start = moment(result.FromDate);
    var end = moment(result.ToDate);
    generateTime(schedule, start._d, end._d);
    //schedule.isPrivate = false;// chance.bool({likelihood: 10});
    schedule.location = result.Description;//chance.address();// result.Description;//
    //schedule.attendees = true;//chance.bool({likelihood: 70}) ? ['anyone']: [];
    //schedule.recurrenceRule = true;// chance.bool({likelihood: 20}) ? 'repeated events' : '';

    schedule.color = calendar.color;
    schedule.bgColor = calendar.bgColor;
    schedule.dragBgColor = calendar.dragBgColor;
    schedule.borderColor = calendar.borderColor;

    //if (schedule.category === 'milestone') {
    //    schedule.color = schedule.bgColor;
    //    schedule.bgColor = 'transparent';
    //    schedule.dragBgColor = 'transparent';
    //    schedule.borderColor = 'transparent';
    //}

    //schedule.raw.memo = chance.sentence();
    schedule.raw.creator.name = result.OwnerId;//chance.name();
    schedule.raw.creator.avatar = chance.avatar();
    //schedule.raw.creator.company = chance.company();
    //schedule.raw.creator.email = chance.email();
    //schedule.raw.creator.phone = chance.phone();

    ScheduleList.push(schedule);
}

function generateSchedule(viewName, renderStart, renderEnd, result) {
    ScheduleList = [];
    for (var i = 0; i < result.length; i++) {
        generateRandomSchedule(CalendarList[0], renderStart, renderEnd, result[i]);
                }
}
