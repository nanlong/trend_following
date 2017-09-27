defmodule TrendFollowingWeb.EmailView do
  use TrendFollowingWeb, :view

  def style do
    """
    <style type="text/css">
    .qmbox * { 
      margin:0; 
      padding:0px; 
    }
    .qmbox #outlook a { 
      padding: 10px; 
    }
    .qmbox body {
      width:100% !important; 
      -webkit-text-size-adjust:100%; 
      -ms-text-size-adjust:100%;
    }
    .qmbox .ExternalClass {
      width:100%;
    }
    .qmbox .ExternalClass,
    .qmbox .ExternalClass p,
    .qmbox .ExternalClass span,
    .qmbox .ExternalClass font,
    .qmbox .ExternalClass td,
    .qmbox .ExternalClass div {
      line-height: 100%;
    }
    .qmbox #backgroundTable {
      margin:0; 
      padding:0; 
      width:100% !important; 
      line-height: 100% !important;
    }
    .qmbox a { 
      color: #0069D6; 
    }
    .qmbox table { 
      width:100%; border:0; 
    }
    .qmbox table tr td { 
      font-size:12px; 
    }
    .qmbox p {
      margin: 0;
      padding: 5px;
      margin-bottom: 15px;
    }
    .qmbox p:last-child {
      margin-bottom: 0;
    }
    .qmbox .qmbtn {
      border-radius: 3px;
      font-size: 16px;
      cursor: pointer;
      border: solid #356DD0;
      border-width: 8px 12px;
      outline: 0 !important;
      text-decoration: none;
      background-color: #356DD0;
      color: #FFF;
      text-align: center;
    }
    .qmbox .text-danger { 
      color: #EB5424; 
    }
    .qmbox .text-muted { 
      color: #999; 
    }
    .qmbox p.lead { 
      font-weight: bold; 
    }
    .qmbox style, 
    .qmbox script, 
    .qmbox head, 
    .qmbox link, 
    .qmbox meta {
      display: none !important;
    }
    </style>
    """
  end
end