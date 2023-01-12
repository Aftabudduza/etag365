using eTagService;
using eTagService.Enums;
using TagService.BO;
using TagService.DA;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace eTag365.Pages.Settings
{
    public partial class AddBasicData : System.Web.UI.Page
    {
        #region Method
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["ChildId"] = null;
                Session["UserId"] = null;
                FillMasterType();
                ddlType.Enabled = true;
                string sessionid = System.Web.HttpContext.Current.Session.SessionID;
                if (!string.IsNullOrEmpty(sessionid))
                {
                    int userid = Utility.IntegerData("SELECT TOP 1 UserId FROM UserLog_Data Where SessionId='" + sessionid + "' Order By LogId DESC");

                    if (userid > 0)
                    {
                        Session["UserId"] = userid;
                        int nContactType = 0;
                        if(Request.QueryString["C"] != null)
                        {
                            try
                            {
                                nContactType = Convert.ToInt32(Request.QueryString["C"].ToString());
                            }
                            catch (Exception ex)
                            {
                                nContactType = 0;
                            }
                        }
                       
                        if (nContactType == 1)
                        {
                            ddlType.SelectedValue = Convert.ToInt32(EnumBasicData.ContactType).ToString();
                            ddlType.Enabled = false;
                            FillGrid();
                        }

                        int nCat = 0;

                        if (Request.QueryString["Cat"] != null)
                        {
                            try
                            {
                                nCat = Convert.ToInt32(Request.QueryString["Cat"].ToString());
                            }
                            catch (Exception ex)
                            {
                                nCat = 0;
                            }
                        }

                       
                        if (nCat == 1)
                        {
                            ddlType.SelectedValue = Convert.ToInt32(EnumBasicData.Category).ToString();
                            ddlType.Enabled = false;
                            FillGrid();
                        }
                    }
                    else
                    {
                        Response.Redirect(Utility.WebUrl + "/login");
                    }
                }
                else
                {
                    Response.Redirect(Utility.WebUrl + "/login");
                }

               
            }
        }
        private void ClearControls()
        {
            txtContactName.Text = "";
            txtCode.Text = "";
            btnSave.Text = "Add";
            //lblHeadline.InnerText = "Add";
        }
        private void FillMasterType()
        {
            try
            {

                ddlType.Items.Clear();
                ddlType.AppendDataBoundItems = true;
                ddlType.Items.Add(new ListItem("Select Parent Type", "-1"));
                ddlType.SelectedValue = "-1";

                ddlType.DataSource = Utility.GetAll<EnumBasicData>();
                ddlType.DataTextField = "Value";
                ddlType.DataValueField = "Key";
                ddlType.DataBind();

            }
            catch (Exception ex)
            {

            }
        }
        private Child SetData(Child objChild)
        {
            objChild = new Child();

            if (Session["ChildId"] != null && Convert.ToInt32(Session["ChildId"]) > 0)
            {
                objChild.Id = Convert.ToInt32(Session["ChildId"].ToString());
            }

            if ((!string.IsNullOrEmpty(txtContactName.Text.ToString())) && (txtContactName.Text.ToString() != string.Empty))
            {
                objChild.Description = txtContactName.Text.ToString();
            }
            else
            {
                objChild.Description = "";
            }
            if ((!string.IsNullOrEmpty(txtCode.Text.ToString())) && (txtCode.Text.ToString() != string.Empty))
            {
                objChild.Code = txtCode.Text.ToString();
            }
            else
            {
                objChild.Code = "";
            }

            if (ddlType.SelectedValue != "-1")
            {
                objChild.UserDefinedId = Convert.ToInt32(ddlType.SelectedValue);

                Master objParent = new MasterDA().GetParentbyUserDefinedID(Convert.ToInt32(ddlType.SelectedValue));
                if (objParent != null)
                {
                    objChild.ParentId = objParent.Id;
                }
                else
                {
                    objChild.ParentId = 0;
                }
            }
            else
            {
                objChild.UserDefinedId = 0;
                objChild.ParentId = 0;
            }

            if (Session["ChildId"] != null)
            {
                objChild.UpdatedBy = Convert.ToInt16(Session["UserId"].ToString());
                objChild.UpdatedDate = DateTime.Now;
            }
            else
            {
                objChild.CreatedBy = Convert.ToInt16(Session["UserId"].ToString());
                objChild.CreatedDate = DateTime.Now;
            }

            if (Session["UserId"] != null)
            {
                objChild.OwnerId = Session["UserId"].ToString();
            }
            else
            {
                objChild.OwnerId = "";
            }

            return objChild;
        }
        private void FillControls(int nId)
        {
            try
            {
                if (nId > 0)
                {
                    Child obj = new ChildDA().GetChildbyID(nId);
                    if (obj != null)
                    {
                        Session["ChildId"] = obj.Id;
                        if (obj.Description != null && obj.Description.ToString() != string.Empty)
                        {
                            txtContactName.Text = obj.Description;
                        }
                        else
                        {
                            txtContactName.Text = "";
                        }
                        if (obj.Code != null && obj.Code.ToString() != string.Empty)
                        {
                            txtCode.Text = obj.Code;
                        }
                        else
                        {
                            txtCode.Text = "";
                        }

                        btnSave.Text = "Update";

                    }
                }
            }
            catch
            {

            }
        }

        private void FillGrid()
        {
            try
            {
                List<Child> objChild = null;
                if (ddlType.SelectedValue != "-1")
                {
                    lblHeadline.InnerText = "Add  " + (ddlType.SelectedItem).Text;

                    int nUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"].ToString()) : 0;

                    if (nUserId > 0)
                    {
                        objChild = new ChildDA().GetChildByUserDefinedIDAndUserID(Convert.ToInt32(ddlType.SelectedValue), nUserId);
                    }

                    //UserProfile objTemp = new UserProfileDA().GetUserByUserID(nUserId);
                    //try
                    //{
                    //    if (objTemp != null)
                    //    {
                    //        if (objTemp.UserTypeContact != null)
                    //        {
                    //            if (objTemp.UserTypeContact == Convert.ToInt32(EnumUserType.Admin).ToString())
                    //            {
                    //                objChild = new ChildDA().GetChildByUserDefinedID(Convert.ToInt32(ddlType.SelectedValue));
                    //            }
                    //            else
                    //            {
                    //                objChild = new ChildDA().GetChildByUserDefinedIDAndUserID(Convert.ToInt32(ddlType.SelectedValue), nUserId);
                    //            }
                    //        }
                    //    }


                    //}
                    //catch (Exception ex)
                    //{

                    //}



                }

                gvDataList.DataSource = objChild;
                gvDataList.DataBind();
            }
            catch (Exception ex)
            {

            }
        }

        public bool ShowEdit(string nCreatedBy)
        {
            bool bShow = false;
            int nUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"].ToString()) : 0;
            UserProfile objTemp = new UserProfileDA().GetUserByUserID(nUserId);
            try
            {
                if (objTemp != null)
                {
                    if (objTemp.UserTypeContact != null)
                    {
                        if (objTemp.UserTypeContact == Convert.ToInt32(EnumUserType.Admin).ToString())
                        {
                            bShow = true;
                        }
                        else
                        {
                            if (nCreatedBy != null)
                            {
                                Child obj = new ChildDA().GetChildbyID(Convert.ToInt32(nCreatedBy));
                                if(obj != null)
                                {
                                    if(obj.CreatedBy != null)
                                    {
                                        if (obj.CreatedBy.ToString() == nUserId.ToString())
                                        {
                                            bShow = true;
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
               
            }
            catch (Exception ex)
            {
                bShow = false;
            }

            return bShow;
        }

        #endregion      
        #region Events

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            try
            {
                Child obj = new Child();
                obj = SetData(obj);                      

                if (Session["ChildId"] == null)
                {
                    if (new ChildDA().Insert(obj))
                    {                       
                        ClearControls();
                        FillGrid();
                        Utility.DisplayMsg((ddlType.SelectedItem).Text.ToString() + " saved successfully!", this);
                    }
                    else
                    {
                        Utility.DisplayMsg((ddlType.SelectedItem).Text.ToString() + "  not saved!", this);
                    }
                }
                else
                {
                    if (new ChildDA().Update(obj))
                    {
                        Session["ChildId"] = null;
                        ClearControls();
                        FillGrid();
                        Utility.DisplayMsg((ddlType.SelectedItem).Text.ToString() + "  updated successfully!", this);
                    }
                    else
                    {
                        Utility.DisplayMsg((ddlType.SelectedItem).Text.ToString() + "  not updated!", this);
                    }
                }
            }
            catch (Exception ex1)
            {

            }
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            ClearControls();
        }
        protected void btnBack_Click(object sender, EventArgs e)
        {
            ClearControls();
            Response.Redirect("/home");
        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvDataList.Rows[row.RowIndex].FindControl("lblId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                if (new ChildDA().DeleteByID(Convert.ToInt32(hdId.Text)))
                {
                    FillGrid();
                    Utility.DisplayMsg((ddlType.SelectedItem).Text.ToString() + "  deleted successfully!", this);
                }
            }
        }
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((LinkButton)sender).Parent.Parent as GridViewRow;
            Label hdId = (Label)gvDataList.Rows[row.RowIndex].FindControl("lblId");

            if (!String.IsNullOrEmpty(hdId.Text))
            {
                FillControls(Convert.ToInt32(hdId.Text));
            }
        }
        protected void gvDataList_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDataList.PageIndex = e.NewPageIndex;
            FillGrid();
        }

        protected void gvDataList_Sorting(object sender, GridViewSortEventArgs e)
        {
            FillGrid();
        }

        protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlType.SelectedIndex > 0)
            {
                FillGrid();
            }
        }

        #endregion
    }
}