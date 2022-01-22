require_relative "eventset.rb"
require "test/unit"

#Test some methods of the Card class
class TestEventSet < Test::Unit::TestCase

    #From test_filter_by_time 1-2, we will test filter_by_requires_rsvp method
    #If the output matches the desired time, the test passes
    def test_filter_by_time1
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_time(Time.new(2021,2,18,15,00,00),Time.new(2021,2,18,20,00,00))
        assert_equal(Time.new(2021,2,18,15,00,00), es.filtered_event_list[0].datetime)
    end

    def test_filter_by_time2
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_time(Time.new(2021,2,18,15,00,00),Time.new(2021,2,18,20,00,00))
        assert_equal(Time.new(2021,2,18,15,30,00), es.filtered_event_list[1].datetime)
    end

    #From test_filter_by_requires_rsvp 1-2, we will test filter_by_requires_rsvp method
    #If the output matches the desired boolean, the test passes
    def test_filter_by_requires_rsvp1
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_requires_rsvp(true)
        assert_equal(true, es.filtered_event_list[0].rsvp_required)
    end

    def test_filter_by_requires_rsvp2
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_requires_rsvp(false)
        assert_equal(false, es.filtered_event_list[0].rsvp_required)
    end

    #From test_filter_by_audience 1-3, we will test filter_by_audience method
    #If the output matches the desired array, the test passes
    def test_filter_by_audience1
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_audience(["Students (Columbus Campus)", "Students (All)", "Faculty/Staff", "Graduate/Professional Students"])
        assert_equal(["Students (Columbus Campus)", "Students (All)", "Faculty/Staff", "Graduate/Professional Students"], es.filtered_event_list[0].audiences)
    end

    def test_filter_by_audience2
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_audience(["Students (All)", "Graduate/Professional Students"])
        assert_equal(["Students (All)", "Graduate/Professional Students"], es.filtered_event_list[1].audiences)
    end

    def test_filter_by_audience3
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_audience(["Students (Columbus Campus)", "Students (All)", "Faculty/Staff", "Parents/Family", "Graduate/Professional Students"])
        assert_equal(["Students (Columbus Campus)", "Students (All)", "Faculty/Staff", "Parents/Family", "Graduate/Professional Students"], es.filtered_event_list[2].audiences)
    end

    #From test_filter_by_program 1-3, we will test filter_by_program method
    #If the output matches the desired array, the test passes
    def test_filter_by_program1
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_program(["OUAB"])
        assert_equal(["OUAB"], es.filtered_event_list[0].programs)
    end

    def test_filter_by_program2
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_program([["Esports"]])
        assert_equal([["Esports"]], es.filtered_event_list[0].programs)
    end

    def test_filter_by_program3
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_program(["Involved Living"])
        assert_equal(["Involved Living"], es.filtered_event_list[0].programs)
    end

    #From test_filter_by_dept 1-3, we will test filter_by_dept method
    #If the output matches the desired array, the test passes
    def test_filter_by_dept1
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_dept(["Student Activities"])
        assert_equal(["Student Activities"], es.filtered_event_list[0].depts)
    end

    def test_filter_by_dept2
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_dept(["Recreational Sports"])
        assert_equal(["Recreational Sports"], es.filtered_event_list[0].depts)
    end

    def test_filter_by_dept3
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_dept(["Multicultural Center"])
        assert_equal(["Multicultural Center"], es.filtered_event_list[0].depts)
    end

    #From test_filter_by_category 1-3, we will test filter_by_category method
    #If the output matches the desired array, the test passes
    def test_filter_by_category1
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_category(["Music", "Movies", "Sports", "Health and Wellness", "Comedy", "Lectures", "Intercultural", "Family Friendly", "Social", "Professional/Personal Development", "Sustainability"])
        assert_equal(["Music", "Movies", "Sports", "Health and Wellness", "Comedy", "Lectures", "Intercultural", "Family Friendly", "Social", "Professional/Personal Development", "Sustainability"], es.filtered_event_list[0].categories)
    end

    def test_filter_by_category2
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_category(["Health and Wellness"])
        assert_equal(["Health and Wellness"], es.filtered_event_list[1].categories)
    end

    def test_filter_by_category3
        es=EventSet.new(["2021/2/18","2021/2/19"])
        es.reset_filters
        es.filter_by_category(["Workshops/Training", "Intercultural"])
        assert_equal(["Music", "Movies", "Sports", "Health and Wellness", "Comedy", "Lectures", "Intercultural", "Family Friendly", "Social", "Professional/Personal Development", "Sustainability"], es.filtered_event_list[0].categories)
    end
end